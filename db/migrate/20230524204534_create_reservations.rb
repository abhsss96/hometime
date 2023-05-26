class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.integer :nights, default: 0
      t.integer :guests, default: 0
      t.integer :adults, default: 0
      t.integer :children, default: 0
      t.integer :infants, default: 0
      t.integer :status
      t.string :currency
      t.integer :guest_id
      t.float :payout_price
      t.float :security_price
      t.float :total_price

      t.timestamps
    end
    add_index :reservations, :code, unique: true
  end
end
