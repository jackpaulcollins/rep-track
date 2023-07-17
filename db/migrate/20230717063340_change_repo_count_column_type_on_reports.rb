class ChangeRepoCountColumnTypeOnReports < ActiveRecord::Migration[7.0]
  def change
    change_column :reports, :rep_count, :float
  end
end
