# == Schema Information
#
# Table name: challenge_units
#
#  id           :bigint           not null, primary key
#  points       :integer
#  rep_name     :string
#  state        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :bigint           not null
#
# Indexes
#
#  index_challenge_units_on_challenge_id  (challenge_id)
#
# Foreign Keys
#
#  fk_rails_...  (challenge_id => challenges.id)
#
class ChallengeUnit < ApplicationRecord
  belongs_to :challenge
  validates :rep_name, presence: true
  validates :points, presence: true

  has_many :reports, dependent: :destroy
  after_save :enqueue_report_point_value_update, if: :points_changed?

  scope :active, -> { where(state: "active") }

  def enqueue_report_point_value_update
    ReportPointValueUpdateJob.perform_later(id)
  end

  state_machine initial: :active do
    event :deactivate do
      transition active: :inactive
    end
  end
end
