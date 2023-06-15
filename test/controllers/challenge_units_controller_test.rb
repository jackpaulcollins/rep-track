require "test_helper"

class ChallengeUnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @challenge_unit = challenge_units(:one)
  end

  test "should get index" do
    get challenge_units_url
    assert_response :success
  end

  test "should get new" do
    get new_challenge_unit_url
    assert_response :success
  end

  test "should create challenge_unit" do
    assert_difference("ChallengeUnit.count") do
      post challenge_units_url, params: {challenge_unit: {challenge_id: @challenge_unit.challenge_id, points: @challenge_unit.points, rep_name: @challenge_unit.rep_name}}
    end

    assert_redirected_to challenge_unit_url(ChallengeUnit.last)
  end

  test "should show challenge_unit" do
    get challenge_unit_url(@challenge_unit)
    assert_response :success
  end

  test "should get edit" do
    get edit_challenge_unit_url(@challenge_unit)
    assert_response :success
  end

  test "should update challenge_unit" do
    patch challenge_unit_url(@challenge_unit), params: {challenge_unit: {challenge_id: @challenge_unit.challenge_id, points: @challenge_unit.points, rep_name: @challenge_unit.rep_name}}
    assert_redirected_to challenge_unit_url(@challenge_unit)
  end

  test "should destroy challenge_unit" do
    assert_difference("ChallengeUnit.count", -1) do
      delete challenge_unit_url(@challenge_unit)
    end

    assert_redirected_to challenge_units_url
  end
end
