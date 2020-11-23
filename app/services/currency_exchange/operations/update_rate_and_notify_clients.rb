require 'net/http'

module CurrencyExchange
  module Operations
    class UpdateRateAndNotifyClients
      def self.perform(from:, to:, notifications_url:)
        rate = UpdateLatestFromSource.perform(from: from, to: to)
        case rate[:status]
        when :success
           exch = rate[:rate]
           if exch.updated_for_notifications?
             # schedule_hit_notifications_url_job(notifications_url)
             notify_clients(notifications_url)
             exch.not_updated_for_notifications!(true)
             {status: :updated}
           else
             {status: :skipped}
           end
         when :error
           {status: :error}
        end
      end

      def self.notify_clients(notifications_url)
         uri = URI.parse(notifications_url)
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true if uri.scheme == 'https'
         http.request(Net::HTTP::Get.new(uri.request_uri))
      # rescue
      end

      def self.schedule_hit_notifications_url_job(notifications_url)
        Jobs::HitNotificationsUrlJob.perform_now(notifications_url)
      end

      private_class_method :schedule_hit_notifications_url_job
    end
  end
end