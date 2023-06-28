Challenge.all.each do |challenge|
  enrollment = challenge.challenge_enrollments.all.sample
  challenge.reports.build(
    account: challenge.account,
    user: enrollment.user,
    challenge_enrollment: enrollment,
    challenge_unit: challenge.challenge_units.all.sample,
    rep_count: rand(1..100)
  ).save!
end