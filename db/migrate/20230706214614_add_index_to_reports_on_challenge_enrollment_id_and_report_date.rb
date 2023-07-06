class AddIndexToReportsOnChallengeEnrollmentIdAndReportDate < ActiveRecord::Migration[7.0]
  def change
    add_index :reports, [:challenge_enrollment_id, :report_date]
  end
end
