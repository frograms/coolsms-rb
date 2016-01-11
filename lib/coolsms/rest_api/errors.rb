module Coolsms
  class RestApi
    class Error < Coolsms::Error
      class << self
        def status; 31000999 end
        def http_status; 500 end
      end

      attr_accessor :api

      def initialize(message = nil, cause = $!)
        if message.is_a?(Hash) && message[:api]
          @api = message.delete(:api)
        end
        super(message, cause)
      end
    end

    class Unimplemented < Error; end

    class ClientError < Error
      class << self
        def status; 31000990 end
        def http_status; 500 end
      end
    end

    class RequestError < Error
      class << self
        def status; 31000100 end
        def http_status; 500 end
      end
    end

    class ResponseError < RequestError
      class << self
        def status; 31000500 end
        def http_status; 500 end
      end

      attr_accessor :status, :headers, :body

      def initialize(message = nil, cause = $!)
        res = message
        res = message.delete(:response) if message.is_a?(Hash) && message[:response]

        case res
        when Faraday::Response then
          self.status = res.status
          self.headers = res.headers
          self.body = res.body
        when Faraday::Env then
          self.status = res.status
          self.headers = res.response_headers
          self.body = res.body
        when Faraday::Error::ClientError then
          self.status = res[:status]
          self.headers = res[:headers]
          self.body = res[:body]
        end
        
        super(message, cause)
      end
    end

    class InvalidJson < ResponseError
      class << self
        def status; 31000510 end
        def http_status; 500 end
      end
    end

    class EmptyResult < ResponseError
      class << self
        def status; 31000520 end
        def http_status; 500 end
      end
    end

    # http://www.coolsms.co.kr/REST_API#Authentication
    class WrongResponseStatus < ResponseError
      class << self
        def status; 31000530 end
        def http_status; 500 end
      end
    end

    class InvalidResultCode < WrongResponseStatus
      class << self
        def status; 31000540 end
        def http_status; 500 end
      end
    end
  end
end
