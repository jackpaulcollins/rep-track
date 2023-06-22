class CreateChallengeInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :challenge_invitations do |t|
      t.references :account, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.references :invited_by, foreign_key: {to_table: :users}
      t.string :email
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
