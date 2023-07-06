class UpdateReportDates < ActiveRecord::Migration[7.0]
  def up
    Report.find_each do |report|
      report.update(report_date: report.created_at.in_time_zone(report.user.time_zone).to_date)
    end
  end
end
