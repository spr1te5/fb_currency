class AddDegreeToExchangeRates < ActiveRecord::Migration[5.2]
  def change
    add_column :currency_exchange_rates, :forced_rate_degree, :integer, limit: 1  	
    add_column :currency_exchange_rates, :source_rate_degree, :integer, limit: 1
  end
end
