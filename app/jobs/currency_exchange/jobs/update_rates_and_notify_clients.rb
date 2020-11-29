module CurrencyExchange
  module Jobs
    class UpdateRatesAndNotifyClients < ApplicationJob
      def perform
        Operations::UpdateRateAndNotifyClients.perform(from: Codes::RUR, to: Codes::USD)
      end
    end
  end
end