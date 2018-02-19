class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      p "SESSION #{session}"
      redirect_to home_path, notice: "Signed in"
    else
      flash.now[:alert] = "Could not sign in"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_path, notice: 'Signed out'
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end

end
