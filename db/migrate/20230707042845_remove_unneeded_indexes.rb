class RemoveUnneededIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :challenge_enrollments, name: "index_challenge_enrollments_on_user_id", column: :user_id
    remove_index :reports, name: "index_reports_on_challenge_enrollment_id", column: :challenge_enrollment_id
  end
end
