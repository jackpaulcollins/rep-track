class ChallengeInvitationsController < ApplicationController
  include ChallengeInvitations::ChallengeInvitationsConcern
  before_action :set_challenge, only: [:create, :show]
  before_action :set_challenge_invitation, only: [:show, :edit, :update, :destroy, :resend, :accept]

  def create
    @challenge_invitation = ChallengeInvitation.for_challenge(@challenge)
    @challenge_invitation.assign_attributes(invitation_params)
    if @challenge_invitation.save_and_send_invite
      redirect_to @challenge, notice: "Invitation was sent to #{@challenge_invitation.email}."
    else
      redirect_to @challenge, status: :unprocessable_entity
    end
  end

  def accept
    user = user_if_present
    challenge = Challenge.unscoped.find(@challenge_invitation.challenge_id)
    if user
      @challenge_invitation.accept!(user, challenge)
      redirect_to challenge, notice: "You've successfully enrolled in #{challenge.name}!"
    else
      puts "*" * 500
      puts request.referer
      store_location_for(:user, request.referer)
      redirect_to new_user_registration_path, alert: "Please sign up to enroll in this challenge"
    end
  end

  def edit
  end

  def update
    if @challenge_invitation.update(invitation_params)
      redirect_to @challenge, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @challenge_invitation.destroy
    redirect_to @challenge_invitation.destroy, status: :see_other, notice: t(".destroyed")
  end

  def resend
    @challenge_invitation.send_invite
    redirect_to @challenge, status: :see_other, notice: t(".sent", email: @challenge_invitation.email)
  end

  private

  def set_challenge_invitation
    @challenge_invitation = ChallengeInvitation.find_by!(token: params[:id])

  rescue ActiveRecord::RecordNotFound
    redirect_to challenges_path, alert: "Invite not found! Please contact the challenge owner"
  end

  def set_challenge
    @challenge = Challenge.unscoped.find(params[:challenge_id])

  rescue ActiveRecord::RecordNotFound
    redirect_to challenges_path, alert: "Invite not found! Please contact the challenge owner"
  end

  def invitation_params
    params
      .require(:challenge_invitation)
      .permit(:name, :email, :challenge_id)
      .merge(invited_by: current_user)
  end
end
