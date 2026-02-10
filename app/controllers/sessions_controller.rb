class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create, :failure ]

  def new
  end

  def create
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in successfully."
    else
      redirect_to login_path, alert: "You are not authorised to access this application."
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Signed out."
  end

  def failure
    redirect_to login_path, alert: "Authentication failed: #{params[:message].humanize}."
  end
end
