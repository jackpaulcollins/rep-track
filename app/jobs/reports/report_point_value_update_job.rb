class Reports::ReportPointValueUpdateJob < ApplicationJob
  queue_as :default

  def perform(challenge_unit_id)
    challenge_unit = ChallengeUnit.find_by(id: challenge_unit_id)
    return unless challenge_unit

    challenge_unit.reports.find_each do |report|
      report.update!(point_value: report.rep_count * challenge_unit.points)
    end
  end
end
