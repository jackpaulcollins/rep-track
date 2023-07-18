# == Schema Information
#
# Table name: challenges
#
#  id                 :bigint           not null, primary key
#  end_date           :date
#  name               :string           not null
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
  include TimelineSerializer

  belongs_to :account
  belongs_to :challenge_owner, class_name: "User"

  has_many :challenge_units, dependent: :destroy
  has_many :challenge_enrollments, dependent: :destroy
  has_many :users, through: :challenge_enrollments
  has_many :reports, dependent: :destroy
  has_many :challenge_invitations, dependent: :destroy

  validates :start_date, presence: true
  validates :name, presence: true

  acts_as_tenant :account
  scope :public_challenges, -> { where(is_public_challenge: true) }

  scope :current_user_enrolled_challenges, ->(user) {
    joins(:challenge_enrollments).where(challenge_enrollments: {user_id: user.id})
  }

  scope :current_user_not_enrolled_challenges, ->(user) {
    joins("LEFT JOIN challenge_enrollments ON challenges.id = challenge_enrollments.challenge_id AND challenge_enrollments.user_id = #{user.id}")
      .where(challenge_enrollments: {id: nil})
  }

  def active_for_user?(user)
    current_time = Time.current.in_time_zone(user.time_zone)
    start_date <= current_time.to_date && (end_date.nil? || end_date >= current_time.to_date)
  end

  def public_data_display
    is_public_challenge ? "Yes" : "No"
  end

  def end_date_display
    end_date || "-"
  end

  def enroll!(user)
    challenge_enrollments.build(user: user, account: account).save!
  end

  def enroll_from_invite!(user, acccount)
    challenge_enrollments.build(user: user, account: account).save!(validate: false)
  end

  def unenroll!(user_id)
    challenge_enrollments.where(user_id: user_id).destroy_all
  end

  def user_can_enroll?(user)
    challenge_enrollments.where(user: user).empty?
  end

  def user_can_edit_challenge?(user, account)
    account.account_users.admin.map(&:user_id).include?(user.id) || is_challenge_owner?(user)
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

  def leaderboard
    reports
      .group(:user)
      .order("SUM(reports.point_value) DESC")
      .sum(:point_value)
  end

  def point_chart_data
    user_ids = top_ten.pluck(:user_id)
    reports_by_user = Report
      .where(challenge_enrollment: challenge_enrollments.where(user_id: user_ids))
      .order(:report_date)
      .pluck(:user_id, :report_date, :point_value)

    top_ten.map do |e|
      reports = reports_by_user.select { |r| r[0] == e.user_id }
      points_by_day = reports.map { |r| [r[1], r[2]] }
      {name: e.user.full_name, data: serialize_along_timeline(points_by_day)}
    end
  end

  def top_ten
    user_ids = Report
      .where(challenge_id: self)
      .group(:user_id)
      .select("reports.user_id, SUM(reports.point_value) as total_point_value")
      .order("total_point_value DESC")
      .limit(10)
      .map { |r| r.user_id }

    challenge_enrollments.includes(:user).where(user_id: user_ids)
  end
end
