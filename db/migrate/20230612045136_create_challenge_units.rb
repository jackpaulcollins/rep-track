class CreateChallengeUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :challenge_units do |t|
      t.string :rep_name
      t.integer :points
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
