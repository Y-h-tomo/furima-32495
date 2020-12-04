class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :purchase   ,null: false, foreign_key: true
      t.string :postal             ,null: false
      t.integer :prefecture_id   ,null: false
      t.text         :city        ,null: false
      t.text       :address       ,null: false
      t.text :building_name
      t.string  :phone_number     ,null: false
      t.timestamps
    end
  end
end
