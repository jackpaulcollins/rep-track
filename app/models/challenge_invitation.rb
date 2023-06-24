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
class ChallengeInvitation < ApplicationRecord
  has_secure_token

  belongs_to :account
  belongs_to :challenge
  belongs_to :invited_by, class_name: "User", optional: true

  validates :name, :email, presence: true
  validates :email, uniqueness: {scope: :account_id, message: :invited}

  def accept!(user, challenge)
    user.add_to_account_from_challenge!(challenge)
    challenge.enroll_from_invite!(user, challenge.account)
    destroy!
  end
  def self.for_challenge(challenge)
    new(challenge: challenge, account: challenge.account)
  end

  def save_and_send_invite
    save && send_invite
  end

  def send_invite
    ChallengeInvitationsMailer.with(challenge_invitation: self).invite.deliver_later
  end

  def to_param
    token
  end
end
