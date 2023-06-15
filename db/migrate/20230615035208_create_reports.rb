class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge_unit, null: false, foreign_key: true
      t.references :challenge_enrollment, null: false, foreign_key: true
      t.integer :rep_count, null: false

      t.timestamps
    end
  end
end
