class TestMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account_invitations_mailer.invite.subject
  #
  def test
    mail(
      to: "jack@reptrack.xyz",
      from: "jack@reptrack.xyz",
      subject: "test"
    )
  end
end