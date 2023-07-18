module Challenges::ChallengeConcern
  extend ActiveSupport::Concern

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
