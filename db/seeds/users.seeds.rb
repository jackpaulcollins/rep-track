rand(1..100).times do
  params = {
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    time_zone: "Pacific Time (US & Canada)",
    accepted_terms_at: DateTime.now,
    accepted_privacy_at: DateTime.now,
    password: "password",
    password_confirmation: "password",
    terms_of_service: true,
  }

  User.create!(params)
end

