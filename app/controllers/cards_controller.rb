class CardsController < ApplicationController
  before_action :find_card, except: [:index, :new, :create]

  def index
    @cards = Card.of_user(current_user).all
  end

  def show
  end

  def edit
  end

  def new
    @card = Card.new
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
    params[:card][:user_id] = current_user.id
    params.require(:card).permit(:original_text, :translated_text, :user_id)
  end

  def find_card
    @card = Card.find(params[:id])
    if @card.user_id != current_user.id
      @card = nil
      redirect_to cards_path
    end
  end
end
