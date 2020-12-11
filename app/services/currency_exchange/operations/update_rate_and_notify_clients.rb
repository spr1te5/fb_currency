require 'net/http'

module CurrencyExchange
  module Operations
    class UpdateRateAndNotifyClients
      def self.perform(from:, to:)
        rate = UpdateLatestFromSource.new.perform(from: from, to: to)
        return rate unless rate.fetch(:status) == :success
        BroadcastRateChanges.new.perform(rate: rate.fetch(:rate))
      end
    end
  end
end