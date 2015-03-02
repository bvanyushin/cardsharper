class AddIsCurrentFieldToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :is_current, :boolean
  end
end
