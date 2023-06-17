class RemoveDefaultAccountValueReport < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reports, :account_id, nil
  end
end
