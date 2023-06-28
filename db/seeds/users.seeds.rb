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

# put accounts here so we have users to sample from
rand(1..25).times do
  params = {
    name: Faker::Name.first_name,
    owner: User.all.sample,
    personal: false,
    extra_billing_info: nil,
    domain: nil,
    subdomain: nil,
    billing_email: nil,
    account_users_count: 1
  }

  Account.create!(params)
end
