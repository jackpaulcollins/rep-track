require "application_system_test_case"

class ChallengesTest < ApplicationSystemTestCase
  setup do
    @challenge = challenges(:one)
    @user = users(:one)
    login_as(@user)
  end

test "visiting the index" do
    visit my_challenges_challenges_path
    assert_selector "h1", text: "My Challenges"
  end

  # test "creating a Challenge" do
  #   visit challenges_url
  #   click_on "New Challenge"

  #   fill_in "Account", with: @challenge.account_id
  #   fill_in "End date", with: @challenge.end_date
  #   fill_in "Name", with: @challenge.name
  #   fill_in "Start date", with: @challenge.start_date
  #   click_on "Create Challenge"

  #   assert_text "Challenge was successfully created"
  #   assert_selector "h1", text: "Challenges"
  # end

  # test "updating a Challenge" do
  #   visit challenge_url(@challenge)
  #   click_on "Edit", match: :first

  #   fill_in "Account", with: @challenge.account_id
  #   fill_in "End date", with: @challenge.end_date
  #   fill_in "Name", with: @challenge.name
  #   fill_in "Start date", with: @challenge.start_date
  #   click_on "Update Challenge"

  #   assert_text "Challenge was successfully updated"
  #   assert_selector "h1", text: "Challenges"
  # end

  # test "destroying a Challenge" do
  #   visit edit_challenge_url(@challenge)
  #   click_on "Delete", match: :first
  #   click_on "Confirm"

  #   assert_text "Challenge was successfully destroyed"
  # end
end
