namespace :challenge_invites do
  desc "bulk invite users to a challenge"
  task :bulk_invite => :environment do
    BulkInviteToChallengeOp.submit!(challenge_id: ENV["CHALLENGE_ID"], invites: ENV["INVITEES"])
  end
end
