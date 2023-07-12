Challenge.all.each do |challenge|
  if challenge.end_date.present?
    (challenge.start_date..challenge.end_date).each do |day|
      challenge.challenge_enrollments.each do |enrollment|
        report = challenge.reports.new(
          account: challenge.account,
          user: enrollment.user,
          challenge_enrollment: enrollment,
          challenge_unit: challenge.challenge_units.all.sample,
          rep_count: rand(1..100)
        )
        report.save!
        report.update_columns(report_date: day)
      end
    end
  else
    (challenge.start_date..challenge.start_date + rand(10..15).days).each do |day|
      challenge.challenge_enrollments.each do |enrollment|
        report = challenge.reports.new(
          account: challenge.account,
          user: enrollment.user,
          challenge_enrollment: enrollment,
          challenge_unit: challenge.challenge_units.all.sample,
          rep_count: rand(1..100)
        )
        report.save!
        report.update_columns(report_date: day)
      end
    end
  end
end
