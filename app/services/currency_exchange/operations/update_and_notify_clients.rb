module CurrencyExchange
  module Operations
    class UpdateAndNotifyClients
      def self.perform(from:, to:)
        rate = UpdateLatestFromSource.perform(from: from, to: to)
        case rate[:status]
        when :success
           exch = rate[:rate]
           puts ">>>>> UPDATED: #{exch.updated_for_notifications?}"
           if exch.updated_for_notifications?
             notify_clients(exch)
             exch.not_updated_for_notifications!(true)
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