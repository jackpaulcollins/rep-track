# == Schema Information
#
# Table name: challenge_enrollments
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#  challenge_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_challenge_enrollments_on_account_id                (account_id)
#  index_challenge_enrollments_on_challenge_id              (challenge_id)
#  index_challenge_enrollments_on_user_id                   (user_id)
#  index_challenge_enrollments_on_user_id_and_challenge_id  (user_id,challenge_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (challenge_id => challenges.id)
#  fk_rails_...  (user_id => users.id)
#
class ChallengeEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  belongs_to :account
  has_many :reports, dependent: :destroy

  acts_as_tenant :account

  def points_by_date
    by_date_with_points = Report.where(challenge_enrollment: self)
      .group(:id, :report_date)
      .order(:report_date).map { |r| [r.report_date, r.point_value] }

    grouped_by_date = by_date_with_points.group_by { |date, _| date }

    dates_and_sum = grouped_by_date.map { |date, array, _| [date, array.sum { |_, a| a }] }

    accumulated_points = 0
    dates_and_sum.each_with_object(Hash.new(0)) do |(date, points), hash|
      hash[date] = points + accumulated_points
      accumulated_points += points
    end
  end
end
