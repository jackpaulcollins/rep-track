class AddAccountToReport < ActiveRecord::Migration[7.0]
  def change
    add_reference :reports, :account, null: false, foreign_key: true, default: 2
  end
end
