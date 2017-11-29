class SessionsController < ApplicationController

  skip_before_action :authenticate_user, only: [:create, :check]

  def destroy
    sign_out
    head :no_content
  end

  def create
    @user = User.find_by_email params[:email]

    if @user && @user.authenticate(params[:password])
      token = sign_in @user
      render json: { session_token: token}
    else
      render json: { errors: ['Wrong email/password combination.'] }, status: :unprocessable_entity
    end
  end

  def check
    if current_session.present?
      head :no_content
    else
      respond_with_errors
    end
  end
end
