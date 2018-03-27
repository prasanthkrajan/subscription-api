class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :subscription, index: true, foreign_key: true
      t.decimal :amount
      t.string :payment_provider
      t.string :status

      t.timestamps null: false
    end
  end
end
