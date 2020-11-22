class CreateRur2UsdExchangeRate < ActiveRecord::Migration[5.2]
  def change
    CurrencyExchangeRate.create! from_code: CurrencyExchange::Codes::RUR,
                                 to_code: CurrencyExchange::Codes::USD,
                                 value: 7600  
  end
end
