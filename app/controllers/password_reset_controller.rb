class PasswordResetController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :update, :show]
  before_action :find_user, only: [:update]
  
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      UserMailer.password_reset(user).deliver_now
      render json: { message: 'Email de recuperação enviado' }, status: :ok
    else
      render json: { error: 'Email não encontrado' }, status: :not_found
    end
  end

  def show
    user = User.find_by(reset_password_token: params["user"][:token])
    
    if user && user.reset_password_token_valid?
      render json: { valid: true, name: user.name }, status: :ok
    else
      render json: { error: 'Token inválido ou expirado' }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(password_params)
      @user.clear_password_reset!
      render json: { message: 'Senha atualizada com sucesso' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find_by(reset_password_token: params["user"][:token])
    return render json: { error: 'Token inválido' }, status: :unprocessable_entity unless @user
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
