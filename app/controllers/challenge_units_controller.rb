class ChallengeUnitsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_challenge_unit, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /challenge_units
  def index
    @pagy, @challenge_units = pagy(ChallengeUnit.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @challenge_units
  end

  # GET /challenge_units/1 or /challenge_units/1.json
  def show
  end

  # GET /challenge_units/new
  def new
    puts params[:challenge_id]
    @challenge_unit = ChallengeUnit.new

    # Uncomment to authorize with Pundit
    # authorize @challenge_unit
  end

  # GET /challenge_units/1/edit
  def edit
  end

  # POST /challenge_units or /challenge_units.json
  def create
    @challenge_unit = ChallengeUnit.new(challenge_unit_params)

    # Uncomment to authorize with Pundit
    # authorize @challenge_unit

    respond_to do |format|
      if @challenge_unit.save
        format.html { redirect_to @challenge_unit, notice: "Challenge unit was successfully created." }
        format.json { render :show, status: :created, location: @challenge_unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @challenge_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /challenge_units/1 or /challenge_units/1.json
  def update
    respond_to do |format|
      if @challenge_unit.update(challenge_unit_params)
        format.html { redirect_to @challenge_unit.challenge, notice: "Challenge rep was successfully updated." }
        format.json { render :show, status: :ok, location: @challenge_unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @challenge_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenge_units/1 or /challenge_units/1.json
  def destroy
    @challenge_unit.destroy
    respond_to do |format|
      format.html { redirect_to @challenge_unit.challenge, status: :see_other, notice: "Challenge rep was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_challenge_unit
    @challenge_unit = ChallengeUnit.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @challenge_unit
  rescue ActiveRecord::RecordNotFound
    redirect_to challenge_units_path
  end

  # Only allow a list of trusted parameters through.
  def challenge_unit_params
    params.require(:challenge_unit).permit(:rep_name, :points, :challenge_id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:challenge_unit).permit(policy(@challenge_unit).permitted_attributes)
  end
end
