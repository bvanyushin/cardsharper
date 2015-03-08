class ProfilesController < ApplicationController
  def set_current_deck
    unless current_user.set_deck(deck_params)
      flash[:deck_message] = "Something wrong happened."
    end
    redirect_to decks_path
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to current_user, notice: "User was successfully updated."
    else
      render action: "edit"
    end
  end

  private

  def deck_params
    params.permit(:current_deck_id)
    params[:current_deck_id]
  end

  def profile_params
    params.require(:current_user).permit(:email, :password, :password_confirmation)
  end
end
