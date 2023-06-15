# == Schema Information
#
# Table name: challenges
#
#  id                 :bigint           not null, primary key
#  end_date           :date
#  name               :string           not null
#  public             :boolean          not null
#  start_date         :date             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint
#  challenge_owner_id :bigint           not null
#
# Indexes
#
#  index_challenges_on_account_id          (account_id)
#  index_challenges_on_challenge_owner_id  (challenge_owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (challenge_owner_id => users.id)
#
class Challenge < ApplicationRecord
  belongs_to :account
  belongs_to :challenge_owner, class_name: "User"
  acts_as_tenant :account
  has_many :challenge_units, dependent: :destroy
  has_many :challenge_enrollments, dependent: :destroy
  has_many :users, through: :challenge_enrollments
  has_many :reports, dependent: :destroy

  validates :start_date, presence: true
  validates :name, presence: true
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :challenges, partial: "challenges/index", locals: {challenge: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :challenges, target: dom_id(self, :index) }

  def public_data_display
    public? ? "Yes" : "No"
  end

  def enroll!(user)
    challenge_enrollments.build(user: user, account: account).save!
  end

  def unenroll!(user)
    challenge_enrollments.where(user: user).destroy_all
  end

  def user_can_enroll?(user)
    challenge_enrollments.where(user: user).empty?
  end

  def user_can_edit_challenge?(user, account)
    account.account_users.admin.map(&:user_id).include?(user.id)
  end

  def is_challenge_owner?(user)
    challenge_owner == user
  end

  def user_enrolled_in_challenge?(user)
    challenge_enrollments.map(&:user_id).include?(user.id)
  end

  def enrollment_for_user(user)
    challenge_enrollments.where(user_id: user.id).take
  end
end
