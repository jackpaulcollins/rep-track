# == Schema Information
#
# Table name: challenge_invitations
#
#  id            :bigint           not null, primary key
#  email         :string
#  name          :string
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  challenge_id  :bigint           not null
#  invited_by_id :bigint
#
# Indexes
#
#  index_challenge_invitations_on_account_id     (account_id)
#  index_challenge_invitations_on_challenge_id   (challenge_id)
#  index_challenge_invitations_on_invited_by_id  (invited_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (challenge_id => challenges.id)
#  fk_rails_...  (invited_by_id => users.id)
#
require "test_helper"

class ChallengeInvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
