class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :register]

  def login
    user = User.find_by(cpf: params[:cpf])
    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { token: token, user: user }
    else
      render json: { error: 'CPF ou senha inválidos' }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)
    if user.save
      token = jwt_encode(user_id: user.id)
      render json: { token: token, user: user }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :cpf, :password, :role)
  end

  def jwt_encode(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end