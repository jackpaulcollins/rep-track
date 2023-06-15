class CreateChallengeEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :challenge_enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end

    add_index :challenge_enrollments, [:user_id, :challenge_id], unique: true
  end
end
