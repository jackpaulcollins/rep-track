# == Schema Information
#
# Table name: reports
#
#  id                      :bigint           not null, primary key
#  rep_count               :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  challenge_enrollment_id :bigint           not null
#  challenge_id            :bigint
#  challenge_unit_id       :bigint           not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_reports_on_challenge_enrollment_id  (challenge_enrollment_id)
#  index_reports_on_challenge_id             (challenge_id)
#  index_reports_on_challenge_unit_id        (challenge_unit_id)
#  index_reports_on_user_id                  (user_id)
#
# Foreign Keys
#
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

  validates :rep_count, presence: true
  validate :challenge_unit_belongs_to_challenge_enrollment

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :reports, partial: "reports/index", locals: {report: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :reports, target: dom_id(self, :index) }

  scope :for_user, ->(user) { where(user: user) }

  def challenge_unit_belongs_to_challenge_enrollment
    challenge_unit.challenge_id == challenge_enrollment.challenge_id
  end

  def point_value
    rep_count * challenge_unit.points
  end
end
