class UserSessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create 
    if @user = login(params[:email], params[:pasword])
      redirect_back_or_to(root_path, flash[:notice] = "Login successful")
    else
      flash.now[:alert] = "Login failed"
      render "new"
    end
  end

  def destroy
    logout
    redirect_to(root_path, flash[:notice] = "Logged out!")
  end
end
