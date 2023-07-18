user = User.create!(
  name: "Admin User",
  email: "jack@reptrack.xyz",
  password: "password",
  password_confirmation: "password",
  terms_of_service: true
)
Jumpstart.grant_system_admin!(user)

Account.create!(
  name: "RepTrack",
  owner: user
)
