namespace :fb_currency do
  desc 'Synchronizes RUR/USD exchange rate and notifies subscribers'
  task synchronize_exchange_rate: :environment do
    CurrencyExchange::Operations::UpdateRateAndNotifyClients.perform(from: CurrencyExchange::Codes::RUR,
                                                                     to: CurrencyExchange::Codes::USD,
                                                                     notifications_url: Figaro.env.exchange_rate_notification_url)

  end
end
