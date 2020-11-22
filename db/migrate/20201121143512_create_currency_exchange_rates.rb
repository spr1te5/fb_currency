class CreateCurrencyExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_exchange_rates do |t|
      t.integer :from_code
      t.integer :to_code
      t.integer :value, limit: 8
      t.date :valid_until

      t.timestamps
    end
  end
end
