class UserSessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create 
    login_params
    if @user = login(params[:email], params[:pasword])
      redirect_back_or_to(users_path, notice: "Login successful")
    else
      flash.now[:alert] = "Login failed"
      render "new"
    end
  end

  def destroy
    logout
    redirect_to(users_path, flash[:notice] = "Logged out!")
  end

  def login_params
    params.permit(:email, :password)
  end
end
