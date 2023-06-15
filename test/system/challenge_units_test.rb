require "application_system_test_case"

class ChallengeUnitsTest < ApplicationSystemTestCase
  setup do
    @challenge_unit = challenge_units(:one)
  end

  test "visiting the index" do
    visit challenge_units_url
    assert_selector "h1", text: "Challenge Units"
  end

  test "creating a Challenge unit" do
    visit challenge_units_url
    click_on "New Challenge Unit"

    fill_in "Challenge", with: @challenge_unit.challenge_id
    fill_in "Points", with: @challenge_unit.points
    fill_in "Rep name", with: @challenge_unit.rep_name
    click_on "Create Challenge unit"

    assert_text "Challenge unit was successfully created"
    assert_selector "h1", text: "Challenge Units"
  end

  test "updating a Challenge unit" do
    visit challenge_unit_url(@challenge_unit)
    click_on "Edit", match: :first

    fill_in "Challenge", with: @challenge_unit.challenge_id
    fill_in "Points", with: @challenge_unit.points
    fill_in "Rep name", with: @challenge_unit.rep_name
    click_on "Update Challenge unit"

    assert_text "Challenge unit was successfully updated"
    assert_selector "h1", text: "Challenge Units"
  end

  test "destroying a Challenge unit" do
    visit edit_challenge_unit_url(@challenge_unit)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Challenge unit was successfully destroyed"
  end
end
