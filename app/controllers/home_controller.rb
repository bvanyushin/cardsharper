class HomeController < ApplicationController
  def index
    @card = Card.where("review_date <= CURRENT_TIMESTAMP").order("RANDOM()").first
  end
end
