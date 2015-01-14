class  CardsController < ApplicationController
  def index
    @cards = Card.all
  end

  def show
    @card = Cards.find(params[:id])
  end

  def new
  end
end
