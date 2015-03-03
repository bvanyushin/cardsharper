class DecksController < ApplicationController
  before_action :find_deck, except: [:index, :new, :create]

  def index
    @decks = current_user.decks
  end

  def show
  end

  def edit
  end

  def new
    @deck = current_user.decks.new
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck
    else
      render "edit"
    end
  end

  def create
    @deck = current_user.decks.new(deck_params)

    if @deck.save 
      redirect_to @deck
    else
      render "new"
    end
  end

  def destroy
    @deck.destroy

    render "index"
  end

  def set_current_deck
    if params.permit(:id) 
      find_deck
      current_user.set_current_deck(@deck)
    end
     redirect_to @deck
  end

  private

  def deck_params
    params.require(:deck).permit(:title)
  end

  def find_deck
    @deck = current_user.decks.find(params[:id])
  end
end
