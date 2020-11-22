module CurrencyExchange
  module Operations
    class UpdateLatestFromSource
      def self.perform(from:, to:)
        source_rate = Sources::CbrRu.retrieve #TODO: refactor
        case source_rate[:status]
        when :success
          latest = RetrieveLatest.perform(from: from, to: to)
          latest.update! source_rate: source_rate[:rate]
          {status: :success, rate: latest}
        when :error
          {status: :error}
        end
      end
    end
  end
end