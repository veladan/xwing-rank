class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :uniqueid
      t.integer :numberOfMatches
      t.integer :ranking

      t.timestamps
    end
  end
end
