class AddPointValueFigureToReports < ActiveRecord::Migration[7.0]
  def up
    Report.find_each do |report|
      puts "updating #{report.id}"
      point_value = report.point_value
      report.update(point_value: point_value)
    end
  end
end
