class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :display_name
      t.string :promo_text
      t.string :promo_text_long, limit: 1024
      t.string :thumnail_path
      t.string :graphic_path
      t.timestamps null: false
    end
  end
end
