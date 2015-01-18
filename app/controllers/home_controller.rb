class HomeController < ApplicationController
  def index
    @card = Card.relevant_for_today.random_sorted.first
  end

  def check_card
    check_params

    @card = Card.find(params[:card_id])
    flash[:message] = @card.review(params[:user_answer])

    redirect_to root_path
  end

  private

  def check_params
    params.permit(:user_answer, :card_id)
  end
end
