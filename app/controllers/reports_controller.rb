class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
  end

  def new
    @challenge = Report.new
  end

  def edit
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report.challenge_enrollment.challenge, notice: "💪 Report was successfully created." }
        format.json { render :show, status: :created, location: @report.challenge }
      else
        format.html { redirect_to @report.challenge_enrollment.challenge, status: :unprocessable_entity, notice: "🚨 #{@report.errors.full_messages.join} 🚨" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report.challenge, notice: "Report was successfully updated." }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, status: :see_other, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to challenges_path
  end

  def report_params
    params.require(:report).permit(:challenge_id, :challenge_unit_id, :challenge_enrollment_id, :rep_count)
  end
end
