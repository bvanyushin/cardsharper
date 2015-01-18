class HomeController < ApplicationController
  def index
    @card = Card.relevant_for_today().random_sorted().first
  end

  def check_card
    check_params

    @card = Card.find(params[:card_id])

    if @card.answer_correct?(params[:user_answer])
      @card.move_review_date!
      flash[:message]  = "Правильно"
    else
      flash[:message]  = "Неправильно"
    end

    redirect_to root_path
  end

  private

  def check_params
    params.permit(:user_answer, :card_id)
  end
end
