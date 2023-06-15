class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :challenges do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :public, null: false
      t.references :account, null: true, foreign_key: true

      t.timestamps
    end
  end
end
