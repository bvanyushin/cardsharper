class CardsController < ApplicationController
  def index
    @cards = Card.all
  end

  def show
    @card = Card.find(params[:id])
  end

  def edit
    @card = Card.find(params[:id])
  end

  def new
    @card = Card.new
  end

  def update
     @card = Card.find(params[:id])

    if @card.update(card_params)
      redirect_to @card
    else
      render 'edit'
    end

  end

  def create
    @card = Card.new(card_params)

    if @card.save 
      redirect_to @card
    else
      render 'new'
    end
  end

  private
    def card_params
      allow = [:original_text, :translated_text]
      params.require(:card).permit(allow)
    end

end
