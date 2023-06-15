require "test_helper"

class ChallengeEnrollmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get enroll" do
    get challenge_enrollments_enroll_url
    assert_response :success
  end

  test "should get unenroll" do
    get challenge_enrollments_unenroll_url
    assert_response :success
  end
end
