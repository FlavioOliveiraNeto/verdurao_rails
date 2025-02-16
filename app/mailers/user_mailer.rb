class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    @url = "#{Rails.application.config.frontend_url}/reset-password?token=#{CGI.escape(@user.reset_password_token)}"
    puts(@url)
    mail(to: @user.email, subject: 'Redefinição de Senha - Verdução Center')
  end
end