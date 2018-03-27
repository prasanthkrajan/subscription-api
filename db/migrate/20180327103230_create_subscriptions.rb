class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :plan_code

      t.timestamps null: false
    end
  end
end
