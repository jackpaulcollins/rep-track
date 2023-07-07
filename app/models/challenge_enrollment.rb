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
    by_date_with_points = Report.includes(:challenge_unit)
      .where(challenge_enrollment: self)
      .group(:id, :report_date)
      .order(:report_date).map { |r| [r.report_date, r.point_value] }

    grouped_by_date = by_date_with_points.group_by { |date, _| date }

    dates_and_sum = grouped_by_date.map { |date, array, _| [date, array.sum { |_, a| a }] }

    accumulated_points = 0
    dates_and_sum.each_with_object(Hash.new(0)) do |(date, points), hash|
      # the first iteration we know there's no previous days
      if hash.empty?
        # set the first date we see to the points earned that day
        hash[date] = points
        # add to the accumlation
        accumulated_points += points
        # go to the next date we see
        next
      # if the next date we see has a gap +1 day from the last date
      elsif date > hash.keys.last + 1.day
        # fill in the in between days based on the last date we saw, up to the date we have with the current accumulation since we know they didn't work those days
        (hash.keys.last + 1.day...date).each { |gap_day| hash[gap_day] = accumulated_points }
        # then set the date we do have work on with the accumulation + points from that date
        hash[date] = accumulated_points + points
        # register the accumulation
        accumulated_points += points
        # go to next record
        next
      else
        # if the record is sequential to the previous, handle as expected
        hash[date] = accumulated_points + points
        accumulated_points += points
      end
      hash[date] = accumulated_points
    end
  end
end
