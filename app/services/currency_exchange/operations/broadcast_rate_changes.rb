module CurrencyExchange
  module Operations
    class BroadcastRateChanges
      CHANNEL_NAME = 'currency_exchange_channel'

      def perform(from: nil, to: nil, rate: nil)
        exch = rate
        unless exch
          latest = RetrieveLatest.new.perform(from: from, to: to) 
          return latest if latest.fetch(:status) != :success
          exch = latest.fetch(:rate)
        end

        if exch.updated_for_notifications?
          exch.not_updated_for_notifications!(true)
          ActionCable.server.broadcast CHANNEL_NAME, rate: exch.rate
          {status: :updated}
        else
          {status: :skipped}
        end
      end
    end
  end
end
