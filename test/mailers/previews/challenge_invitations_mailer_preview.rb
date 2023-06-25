# Preview all emails at http://localhost:3000/rails/mailers/
class ChallengeInvitationsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/challenge_invitations_mailer/invite
  def invite
    account = Account.new(name: "Example Account")
    challenge = Challenge.new(account: account, name: "Example")
    challenge_invitation = ChallengeInvitation.new(id: 1, challenge: challenge, token: "fake", account: account, name: "Test User", email: "test@example.com", invited_by: User.first)
    ChallengeInvitationsMailer.with(challenge_invitation: challenge_invitation).invite
  end
end
