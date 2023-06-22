class AddChallengeToAccountInvitations < ActiveRecord::Migration[7.0]
  def change
    add_reference :account_invitations, :challenge, foreign_key: true
  end
end
