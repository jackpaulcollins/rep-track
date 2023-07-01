module ChallengeInvitations::ChallengeInvitationsConcern
  extend ActiveSupport::Concern

  def user_if_present
    matched_from_invite = User.find_by_email(@challenge_invitation.email)
    return matched_from_invite if matched_from_invite.present?
    return current_user if current_user.present?

    nil
  end
end
