module ChallengeInvitations::ChallengeInvitationsConcern
  extend ActiveSupport::Concern

  def user_if_present
    User.find_by_email(@challenge_invitation.email)
  end
end
