class AddSourceRateFieldToExchangeRate < ActiveRecord::Migration[5.2]
  def change
  	add_column :currency_exchange_rates, :source_rate, :integer, limit: 8
  end
end
