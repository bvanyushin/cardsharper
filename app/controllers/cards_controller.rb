class CardsController < ApplicationController
  before_action :find_card, except: [:index, :new, :create]

  def index
    @cards = current_user.cards
  end

  def show
  end

  def edit
  end

  def new
    @card = current_user.cards.new
  end

  def update
    if @card.update(card_params)
      redirect_to @card
    else
      render "edit"
    end
  end

  def create
    @card = Card.new(card_params)

    if @card.save 
      redirect_to @card
    else
      render "new"
    end
  end

  def destroy
    @card.destroy

    redirect_to cards_path
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :picture)
  end

  def find_card
    @card = current_user.cards.find(params[:id])
  end
end
