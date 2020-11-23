class AddUpdatedFlagToExchangeRate < ActiveRecord::Migration[5.2]
  def change
  	add_column :currency_exchange_rates, :updated, :boolean 	
  end
end
