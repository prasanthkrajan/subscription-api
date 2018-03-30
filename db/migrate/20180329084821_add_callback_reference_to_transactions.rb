class AddCallbackReferenceToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :transaction_ref, :string
  end
end
