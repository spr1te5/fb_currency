require 'net/http'

module CurrencyExchange
  module Sources
    class CbrRu
      VALUE_MASK = /<td[^>]*>840<\/td>\s*<td[^>]*>[^<]*<\/td>\s*<td[^>]*>[^<]*<\/td>\s*<td[^>]*>[^<]*<\/td>\s*<td[^>]*>([0-9\.\,]*)<\/td>/im
	    REQUEST_URI = 'https://www.cbr.ru/currency_base/daily/'

	    # :nodoc:
	    def self.retrieve
       	 uri = URI.parse(REQUEST_URI)
         http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = true if uri.scheme == 'https'
         html = http.request(Net::HTTP::Get.new(uri.request_uri)).body
         {status: :success, rate: extract_rate_from_string(html)}
      rescue => e
         {status: :error, errors: [e.message]}
      end

      # :nodoc:
      def self.extract_rate_from_string(source)
       	source =~ VALUE_MASK
        value = $1
        value.sub!(/\,/, '.')
        value.to_f 
      end

		  private_class_method :extract_rate_from_string      
    end
  end
end