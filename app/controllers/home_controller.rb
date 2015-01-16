class HomeController < ApplicationController
  def index
    @card = Card.where("review_date <= CURRENT_TIMESTAMP").order("RANDOM()").first
    flash[:text_to_check] = @card.translated_text
    flash[:card_id] = @card.id
  end

  def check_card    
    if flash[:text_to_check] == :user_answer
      @card = Card.find(flash[:card_id])
      @card.review_date = Time.now.midnight + 3.day
      @card.save
      flash[:message]  = "Правильно"
    else
      flash[:message]  = "Неравильно"
    end

    redirect_to home_index_path
  end

end

