# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
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
