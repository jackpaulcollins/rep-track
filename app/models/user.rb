# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  accepted_privacy_at    :datetime
#  accepted_terms_at      :datetime
#  admin                  :boolean
#  announcements_read_at  :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string
#  last_otp_timestep      :integer
#  otp_backup_codes       :text
#  otp_required_for_login :boolean
#  otp_secret             :string
#  preferred_language     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  time_zone              :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  default_account_id     :bigint
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_default_account_id                 (default_account_id)
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (default_account_id => accounts.id)
#

class User < ApplicationRecord
  include ActionText::Attachable
  include PgSearch::Model
  include TwoFactorAuthentication
  include UserAccounts
  include UserAgreements

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :omniauthable

  has_noticed_notifications
  has_person_name

  pg_search_scope :search_by_full_name, against: [:first_name, :last_name], using: {tsearch: {prefix: true}}

  # ActiveStorage Associations
  has_one_attached :avatar

  # Associations
  has_many :api_tokens, dependent: :destroy
  has_many :connected_accounts, as: :owner, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :notification_tokens, dependent: :destroy
  has_many :challenges, through: :challenge_enrollments, dependent: :destroy
  has_many :challenges, class_name: "Challenge", foreign_key: "challenge_owner_id", dependent: :destroy
  has_many :challenge_enrollments, dependent: :destroy
  has_many :reports, dependent: :destroy
  belongs_to :default_account, class_name: "Account", foreign_key: "default_account_id", optional: true

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!

  # Protect admin flag from editing
  attr_readonly :admin

  # Validations
  validates :name, presence: true
  validates :avatar, resizable_image: true
  before_validation :set_default_timezone

  def has_default_account?
    !default_account.nil?
  end

  # When ActionText rendering mentions in plain text
  def attachable_plain_text_representation(caption = nil)
    caption || name
  end

  def set_default_timezone
    self.time_zone ||= "Pacific Time (US & Canada)" if time_zone.nil?
  end

  def add_to_account_from_challenge!(c)
    return if account_users.map(&:account_id).include?(c.account.id)
    c.account.account_users.create!(user: self, roles: {"admin" => false, "member" => true})
    reload
  end

  def full_name
    full_name = [first_name, last_name].compact.join(" ")
    if full_name.length > 10
      last_initial = last_name[0].upcase + "."
      full_name = [first_name, last_initial].compact.join(" ")
    end
    full_name
  end
end
