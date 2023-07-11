# == Schema Information
#
# Table name: reports
#
#  id                      :bigint           not null, primary key
#  point_value             :float
#  rep_count               :integer          not null
#  report_date             :date
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :bigint           not null
#  challenge_enrollment_id :bigint           not null
#  challenge_id            :bigint
#  challenge_unit_id       :bigint           not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_reports_on_account_id                               (account_id)
#  index_reports_on_challenge_enrollment_id_and_report_date  (challenge_enrollment_id,report_date)
#  index_reports_on_challenge_id                             (challenge_id)
#  index_reports_on_challenge_unit_id                        (challenge_unit_id)
#  index_reports_on_user_id                                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (challenge_enrollment_id => challenge_enrollments.id)
#  fk_rails_...  (challenge_id => challenges.id)
#  fk_rails_...  (challenge_unit_id => challenge_units.id)
#  fk_rails_...  (user_id => users.id)
#
class Report < ApplicationRecord
  belongs_to :user
  belongs_to :challenge_unit
  belongs_to :challenge_enrollment
  belongs_to :challenge
  belongs_to :account

  acts_as_tenant :account

  validates :rep_count, presence: true
  validate :challenge_unit_belongs_to_challenge_enrollment

  before_save :set_report_date
  before_save :calculate_point_value

  scope :for_user, ->(user) { where(user: user) }

  def calculate_point_value
    self.point_value = self.rep_count * self.challenge_unit.points
  end

  def set_report_date
    self.report_date = DateTime.now.in_time_zone(user.time_zone).to_date
  end

  def challenge_unit_belongs_to_challenge_enrollment
    challenge_unit.challenge_id == challenge_enrollment.challenge_id
  end

  def point_value
    rep_count * challenge_unit.points
  end
end
