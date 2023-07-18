require_relative "../services/bulk_invite_service"

class ChallengesController < ApplicationController
  include Challenges::ChallengeConcern
  before_action :set_challenge, only: [:user_reports, :bulk_invite, :submit_bulk_invite, :show, :edit, :update, :destroy, :add_units, :new_unit_form, :chart_data]
  before_action :authenticate_user!

  def chart_data
    render json: @challenge.point_chart_data
  end

  def user_reports
    @user = User.find(params[:user_id])

    @user_reports_by_challenge_unit = @user.reports.joins(:challenge_unit)
      .where(challenge_units: {challenge: @challenge})
      .group_by { |report| [report.challenge_unit, report.created_at.to_date] }

    render :user_challenge_reports
  end

  def current_user_challenges
    @pagy, @challenges = pagy(Challenge.current_user_enrolled_challenges(current_user).sort_by_params(params[:sort], sort_direction))
  end

  def bulk_invite
    redirect_to @challenge unless @challenge.is_challenge_owner?(current_user)
  end

  def submit_bulk_invite
    csv = params[:csv_file].tempfile
    service = ::BulkInviteService.new(user: current_user, challenge: @challenge, csv: csv)
    service.process_csv
  end

  def index
    @pagy, @challenges = pagy(Challenge.current_user_not_enrolled_challenges(current_user).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @challenges
  end

  # GET /challenges/1 or /challenges/1.json
  def show
  end

  # GET /challenges/new
  def new
    @challenge = Challenge.new

    # Uncomment to authorize with Pundit
    # authorize @challenge
  end

  # GET /challenges/1/edit
  def edit
  end

  def new_unit_form
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "#{@challenge.id}_add_unit",
          partial: "new_challenge_unit_form",
          locals: {challenge: @challenge}
        )
      end
    end
  end

  def add_units
    units_params = params.require(:challenge_units).map { |unit| unit.require(:challenge_unit).permit! }

    errors = validate_units(units_params)

    return handle_invalid_challenge_units(errors) if errors.present?

    respond_to do |format|
      format.html { redirect_to @challenge, notice: "Challenge created." }
      format.json { render :show, status: :created, location: @challenge_unit }
    end
  end

  # POST /challenges or /challenges.json
  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.challenge_owner = current_user

    respond_to do |format|
      if @challenge.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_challenge_placeholder",
            partial: "challenge_units_form",
            locals: {challenge: @challenge}
          )
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /challenges/1 or /challenges/1.json
  def update
    respond_to do |format|
      if @challenge.update(challenge_params)
        format.html { redirect_to @challenge, notice: "Challenge was successfully updated." }
        format.json { render :show, status: :ok, location: @challenge }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1 or /challenges/1.json
  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, status: :see_other, notice: "Challenge was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_challenge
    @challenge = Challenge.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @challenge
  rescue ActiveRecord::RecordNotFound
    redirect_to challenges_path
  end

  def challenge_params
    params.require(:challenge).permit(:name, :start_date, :end_date, :account_id)
  end
end
