class ApplicationController < ActionController::API
  attr_reader :current_user, :header
  def not_found
    render json: { error: 'not_found' }
  end
  def authorize_request
    header = request.headers['Authorization']
    header.split(' ').last if header
    begin
      decoded = Auth::JsonWebToken.decode(header)
      current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private
  def current_user
    @current_user ||= User.find(decode[:user_id])
  end
end
