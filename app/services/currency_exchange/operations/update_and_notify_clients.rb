module CurrencyExchange
  module Operations
    class UpdateAndNotifyClients
      def self.perform(from:, to:)
        rate = UpdateLatestFromSource.perform(from: from, to: to)
        case rate[:status]
        when :success
           exch = rate[:rate]
           if exch.chanded_for_notification?
             notify_clients(exch)
             {status: :updated}
           else
             {status: :skipped}
           end
         when :error
           {status: :error}
        end
      end

      def self.notify_clients(exch)
        #TODO: schedule bg/job
        ActionCable.server.broadcast 'currency_exchange_channel', rate: exch.rate
      end
    end
  end
end