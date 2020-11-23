module CurrencyExchange
  module Operations
    class UpdateLatestFromSource
      cattr_accessor :sources

      self.sources = {
        "#{Codes::RUR}_#{Codes::USD}" => Sources::CbrRu
      }

      def self.perform(from:, to:)
        source = sources.fetch("#{from}_#{to}")
        source_rate = source.retrieve
        case source_rate[:status]
        when :success
          latest = RetrieveLatest.perform(from: from, to: to)
          latest.source_rate = source_rate[:rate]
          {status: :success, rate: latest}
        when :error
          {status: :error}
        end
      end
    end
  end
end