class AddDeckKeyToCard < ActiveRecord::Migration
  def change
    add_reference :cards, :deck, index: true
    add_foreign_key :cards, :decks
  end
end
