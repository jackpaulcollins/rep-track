class RemoveChallengesFromAccountInvitations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :account_invitations, :challenge, foreign_key: true
  end
end
