class AddReportDateToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :report_date, :date
  end
end
