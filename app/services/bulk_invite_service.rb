require "csv"

class BulkInviteService
  def initialize(user:, challenge:, csv:)
    @user = user
    @challenge = challenge
    @csv = csv
  end

  def process_csv
    CSV.foreach(@csv.path, headers: true) do |row|
      name = row["Name"]
      email = row["Email Address"]
      invite_user(name, email)
    end
  end

  private

  def invite_user(name, email)
    invite = ChallengeInvitation.for_challenge(@challenge)
    invite.invited_by = @user
    invite.name = name
    invite.email = email
    invite.save_and_send_invite
  end
end
