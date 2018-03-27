class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :msisdn

      t.timestamps null: false
    end
  end
end
