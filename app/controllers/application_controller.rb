class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        @decoded = jwt_decode(token) # Decodifica o token
        @current_user = User.find(@decoded[:user_id]) # Encontra o usuário com base no user_id
      rescue JWT::DecodeError => e
        Rails.logger.error "Erro ao decodificar token: #{e.message}"
        render json: { error: 'Não autorizado' }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "Usuário não encontrado: #{e.message}"
        render json: { error: 'Não autorizado' }, status: :unauthorized
      end
    else
      Rails.logger.error "Cabeçalho de autorização ausente"
      render json: { error: 'Cabeçalho de autorização ausente' }, status: :unauthorized
    end
  end

  def jwt_decode(token)
    # Decodifica o token usando a chave secreta e o algoritmo HS256
    decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
    # Retorna o payload do token como um hash com símbolos como chaves
    HashWithIndifferentAccess.new(decoded[0])
  end
end