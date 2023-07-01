class AddDefaultAccountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :default_account, foreign_key: {to_table: :accounts}, null: true
  end
end
