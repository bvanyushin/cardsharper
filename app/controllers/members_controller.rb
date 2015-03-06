class MembersController < ApplicationController
  def set_current_deck
    unless current_user.set_deck(deck_params) 
      flash[:deck_message] = "Something wrong happened."
    end
    redirect_to decks_path
  end

  private

  def deck_params
    params.permit(:current_deck_id)
  end
end