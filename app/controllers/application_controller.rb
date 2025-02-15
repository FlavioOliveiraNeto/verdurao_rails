class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = jwt_decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def jwt_decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
  end
end