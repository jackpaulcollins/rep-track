module Challenges::ChallengeConcern
  extend ActiveSupport::Concern

  def handle_public_challenge
    ActsAsTenant.with_tenant(current_user.personal_account) do
      @challenge.account_id = current_user.personal_account.id
      respond_to do |format|
        if @challenge.save
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "new_challenge_placeholder",
              partial: "challenges/challenge_units_form",
              locals: {challenge: @challenge}
            )
          end
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @challenge.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def validate_units(units_params)
    units_params.each do |unit_params|
      @challenge.challenge_units.build(unit_params)
      @challenge.challenge_units.each(&:save)
    end

    return if @challenge.challenge_units.all?(:valid?)

    @challenge.challenge_units.map { |cu| cu.errors.full_messages }.first
  end

  def handle_invalid_challenge_units(error_messages)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "challenge-#{@challenge.id}-units-notice",
          partial: "challenge_units_form_notice",
          locals: {messages: error_messages}
        )
      end
    end
  end
end
