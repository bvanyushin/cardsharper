class CardChange < ActiveRecord::Migration
  def change
    add_attachment :cards, :picture
  end
end
