class RenameExchangeRateValue < ActiveRecord::Migration[5.2]
  def change
  	rename_column :currency_exchange_rates, :value, :forced_rate
  end
end
