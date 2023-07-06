# == Schema Information
#
# Table name: challenges
#
#  id                  :bigint           not null, primary key
#  end_date            :date
#  is_public_challenge :boolean          default(FALSE), not null
#  name                :string           not null
#  start_date          :date             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint
#  challenge_owner_id  :bigint           not null
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
    reports_by_user = reports.group_by { |report| report.user }

    leaderboard = reports_by_user.each_with_object({}) do |(user, reports), hash|
      hash[user] = reports.sum(&:point_value)
    end

    leaderboard.sort_by { |_, value| value }.reverse.to_h
  end

  def point_chart_data(current_user)
    data = challenge_enrollments.map { |e| {name: e.user.full_name, data: get_daily_points(e, current_user)} }
    sorted_by_sum = data.sort_by { |data| -data[:data].values.sum }
    # only show the top ten or chartkick gets crowded
    sorted_by_sum.take(10)
  end

  def get_daily_points(enrollment, current_user)
    date_range = start_date.to_date..Date.today.to_date + 1.day

    points = 0
    date_range.map { |d| [d.to_s, points += enrollment.points_by_date(d)] }.to_h
  end
end
