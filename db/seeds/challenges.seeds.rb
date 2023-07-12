Account.all.each do |account|
  rand(5..25).times do
    start_date = Faker::Date.between(from: 3.months.ago, to: Date.today + 3.months)
    public_challenge = rand(4).zero?
    challenge = Challenge.new(
      name: Faker::Name.first_name,
      start_date: start_date,
      # 50% shot of being ongoing
      end_date: rand(2).zero? ? Faker::Date.between(from: start_date + 1.week, to: start_date + 2.weeks) : nil,
      # 25% shot of being public
      is_public_challenge: public_challenge,
      account_id: account.id,
      challenge_owner_id: account.owner.id
    )

    if public_challenge
      ActsAsTenant.with_tenant(Account.default_account) do
        challenge.save!
      end
    else
      challenge.save!
    end
    # create the challenge units now too

    rand(1..5).times do
      challenge.challenge_units.build(
        rep_name: Faker::Lorem.characters(number: 10),
        points: rand(1..5)
      ).save!
    end

    User.all.each do |user|
      challenge.enroll_from_invite!(user, challenge.account)
    end
  end
end
