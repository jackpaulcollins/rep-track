class AddPointTotalToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :point_value, :float
  end
end
