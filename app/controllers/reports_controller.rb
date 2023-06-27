class ReportsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
  end

  def new
    @challenge = Report.new
  end

  def edit
    @report = Report.find(params[:id])
    render turbo_stream: turbo_stream.replace(dom_id(@report, "edit-form"), partial: "reports/edit_form")
  end

  def index
    @pagy, reports = pagy(Report.includes(:challenge).for_user(current_user).sort_by_params(params[:sort], sort_direction))

    @reports_by_challenge = reports.group_by { |report| report.challenge.name }
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user

    if @report.challenge.active_for_user?(current_user)
      respond_to do |format|
        if @report.save
          format.html { redirect_to @report.challenge_enrollment.challenge, notice: "💪 Report was successfully created." }
          format.json { render :show, status: :created, location: @report.challenge }
        else
          format.html { redirect_to @report.challenge_enrollment.challenge, status: :unprocessable_entity, notice: "🚨 #{@report.errors.full_messages.join} 🚨" }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @report.challenge_enrollment.challenge, alert: "Challenge is not currently active."
    end
  end

  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to reports_path, notice: "Report was successfully updated." }
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
      format.html { redirect_to reports_path, status: :see_other, notice: "Report was successfully destroyed." }
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
