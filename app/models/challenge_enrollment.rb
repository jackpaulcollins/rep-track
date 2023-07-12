# == Schema Information
#
# Table name: challenge_enrollments
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#  challenge_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_challenge_enrollments_on_account_id                (account_id)
#  index_challenge_enrollments_on_challenge_id              (challenge_id)
#  index_challenge_enrollments_on_user_id_and_challenge_id  (user_id,challenge_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (challenge_id => challenges.id)
#  fk_rails_...  (user_id => users.id)
#
class ChallengeEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  belongs_to :account
  has_many :reports, dependent: :destroy

  acts_as_tenant :account
end
