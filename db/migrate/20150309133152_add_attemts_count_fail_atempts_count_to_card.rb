class AddAttemtsCountFailAtemptsCountToCard < ActiveRecord::Migration
  def change
    add_column :cards, :attempt_count, :integer, :default => 0
    add_column :cards, :failed_attempt_count, :integer, :default => 0
  end
end
