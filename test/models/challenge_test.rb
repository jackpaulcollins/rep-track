# == Schema Information
#
# Table name: challenges
#
#  id                  :bigint           not null, primary key
#  end_date            :date
#  is_public_challenge :boolean          default(FALSE), not null
#  name                :string           not null
#  start_date          :date             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint
#  challenge_owner_id  :bigint           not null
#
# Indexes
#
#  index_challenges_on_account_id          (account_id)
#  index_challenges_on_challenge_owner_id  (challenge_owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (challenge_owner_id => users.id)
#
require "test_helper"

class ChallengeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
