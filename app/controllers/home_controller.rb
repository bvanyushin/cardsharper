class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]
  def index
    if current_user.present?
      @deck = current_user.decks.find(current_user.deck_id)
      if @deck.present?
        @card = @deck.cards.relevant_for_today.first
      else
        @card = current_user.cards.relevant_for_today.first
      end
    end
  end

  def review_card
    @card = Card.find(review_params[:card_id])
    if @card.review(params[:user_answer])
      flash[:message] = "Правильно"
    else
      flash[:message] = "Неправильно"
    end

    redirect_to root_path
  end

  private

  def review_params
    params.permit(:user_answer, :card_id)
  end
end
