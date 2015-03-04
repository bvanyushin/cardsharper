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
    unless @deck.current? current_user.id
      @deck.destroy
      redirect_to decks_path
      return
    end
    flash[:deck_message] = "Нельзя удалить текущую колоду. Для удаления назначьте другую колоду текущей."
    redirect_to decks_path
  end

  private

  def deck_params
    params.require(:deck).permit(:title)
  end

  def find_deck
    @deck = current_user.decks.find(params[:id])
  end
end
