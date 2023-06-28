user = User.create!(
  name: "Admin User",
  email: "jack@reptrack.xyz",
  password: "password",
  password_confirmation: "password",
  terms_of_service: true,
  skip_add_to_default_account: true
)
Jumpstart.grant_system_admin!(user)

Account.create!(
  name: "RepTrack",
  owner: user
)

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
