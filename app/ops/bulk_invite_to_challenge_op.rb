class BulkInviteToChallengeOp < ::Subroutine::Op
  integer :challenge_id
  string :invites

  def perform
    invites = parse_invites(self.invites)
    invites.each { |invite| create_and_send_invite!(invite) }
  end

  protected

  # ["email", "name"]
  def parse_invites(string)
    by_line = string.split("\n")
    by_line.map { |line| line.split("\t") }
  end

  def create_and_send_invite!(invite)
    challenge = challenge(challenge_id)
    puts "inviting #{invite[1]} with email: #{invite[0]} to challenge: #{challenge.name}"
    invite_record = ChallengeInvitation.for_challenge(challenge)
    invite_record.email = invite[0]
    invite_record.name = invite[1]
    invite_record.invited_by = User.find_by_email("jack@reptrack.xyz")
    invite_record.save_and_send_invite
  end

  def challenge(id)
    Challenge.find(id)
  end
end
