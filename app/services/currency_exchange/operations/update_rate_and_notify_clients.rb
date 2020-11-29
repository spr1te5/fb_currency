require 'net/http'

module CurrencyExchange
  module Operations
    class UpdateRateAndNotifyClients
      def self.perform(from:, to:)
        rate = UpdateLatestFromSource.perform(from: from, to: to)
        return rate unless rate.fetch(:status) == :success
        BroadcastRateChanges.perform(rate: rate.fetch(:rate))
      end
    end
  end
end