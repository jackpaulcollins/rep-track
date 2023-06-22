class ChallengeInvitationsController < ApplicationController
  before_action :set_challenge, only: [:create]
  before_action :set_challenge_invitation, only: [:show, :edit, :update, :destroy, :resend]

  def create
    @challenge_invitation = ChallengeInvitation.for_challenge(@challenge)
    @challenge_invitation.assign_attributes(invitation_params)
    if @challenge_invitation.save_and_send_invite
      redirect_to @challenge, notice: "Invitation was sent to #{@challenge_invitation.email}."
    else
      redirect_to @challenge, status: :unprocessable_entity
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
  end

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def invitation_params
    params
      .require(:challenge_invitation)
      .permit(:name, :email, :challenge_id)
      .merge(invited_by: current_user)
  end
end
