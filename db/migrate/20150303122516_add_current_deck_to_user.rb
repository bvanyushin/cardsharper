class AddCurrentDeckToUser < ActiveRecord::Migration
  def change
    add_reference :users, :deck, index: true
    add_foreign_key :users, :decks, name: :current_deck
  end
end
