class ChallengeEnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:enroll, :unenroll]

  def enroll
    respond_to do |format|
      if @challenge.enroll!(current_user)
        format.html { redirect_to @challenge, notice: "Successfully enrolled in challenge! 😀" }
        format.json { render :show, status: :ok, location: @challenge }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  def unenroll
    respond_to do |format|
      if @challenge.unenroll!(current_user)
        format.html { redirect_to @challenge, notice: "Successfully unenrolled in challenge 😔" }
        format.json { render :show, status: :ok, location: @challenge }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to challenges_path
  end
end
