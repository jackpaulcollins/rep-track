class DashboardController < ApplicationController
  def show
    @available_challenges = Challenge.all
  end
end
