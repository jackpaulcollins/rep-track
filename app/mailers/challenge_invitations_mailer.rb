class ChallengeInvitationsMailer < ApplicationMailer
  def invite
    @challenge_invitation = params[:challenge_invitation]
    @account = @challenge_invitation.account
    @challenge = @challenge_invitation.challenge
    @invited_by = @challenge_invitation.invited_by

    mail(
      to: email_address_with_name(@challenge_invitation.email, @challenge_invitation.name),
      from: email_address_with_name(Jumpstart.config.support_email, @invited_by.name),
      subject: t(".subject", inviter: @invited_by.name, challenge_name: @challenge.name)
    )
  end
end
