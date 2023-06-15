class ChallengesController < ApplicationController
  include Challenges::ChallengeConcern
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :add_units]
  before_action :authenticate_user!

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /challenges
  def index
    @pagy, @challenges = pagy(Challenge.sort_by_params(params[:sort], sort_direction))

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

    # ensures the account id is the user's personal account
    return handle_public_challenge if @challenge.public?

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
    params.require(:challenge).permit(:name, :start_date, :end_date, :public, :account_id)
  end
end
