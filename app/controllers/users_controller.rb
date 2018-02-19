class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:notice] = "Successfully created..."
      redirect_to home_path
    else
      render :new, notice: "Could not create user"
    end 
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
