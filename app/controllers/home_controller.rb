class HomeController < ApplicationController
  def index
    @card = Card.where("review_date <= ?", Time.now).order("RANDOM()").first
    if @card != nil
      flash[:card_id] = @card.id
    end
  end

  def check_card
    @user_answers = params.permit(:user_answer)
    @user_answer = @user_answers[:user_answer]

    @card = Card.find(flash[:card_id])

    if @card.translated_text == @user_answer
      @card.review_date = Time.now.midnight + 3.day
      @card.save
      flash[:message]  = "Правильно"
    else
      flash[:message]  = "Неправильно"
    end

    redirect_to home_index_path
  end
end
