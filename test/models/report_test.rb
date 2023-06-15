# == Schema Information
#
# Table name: reports
#
#  id                      :bigint           not null, primary key
#  rep_count               :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  challenge_enrollment_id :bigint           not null
#  challenge_unit_id       :bigint           not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_reports_on_challenge_enrollment_id  (challenge_enrollment_id)
#  index_reports_on_challenge_unit_id        (challenge_unit_id)
#  index_reports_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (challenge_enrollment_id => challenge_enrollments.id)
#  fk_rails_...  (challenge_unit_id => challenge_units.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
