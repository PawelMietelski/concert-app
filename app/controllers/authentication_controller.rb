class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    user = User.find_by_email(params[:email])
    if user.authenticate(params[:password])
      token = Auth::JsonWebToken.encode(user_id: user.id)
      render json: { token: token, email: user.email }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def logout
    header
  end

  private

  def params
    params.permit(:email, :password)
  end
end
