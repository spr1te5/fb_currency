module CurrencyExchange
  module Operations
    class BroadcastRateChanges
      def self.perform(from:, to:)
        exch = RetrieveLatest.perform(from: from, to: to)
        if exch.updated_for_notifications?
          exch.not_updated_for_notifications!(true)
          ActionCable.server.broadcast 'currency_exchange_channel', rate: exch.rate
          {status: :updated}
        else
          {status: :skipped}
        end
      end
    end
  end
end
