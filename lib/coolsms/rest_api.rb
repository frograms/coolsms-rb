require 'active_support/core_ext/object/to_query'
require 'securerandom'

module Coolsms
  class RestApi
    cattr_writer :url,
                 :api_key, :api_secret

    class << self
      def url;        @@url        || Coolsms.url        end
      def api_key;    @@api_key    || Coolsms.api_key    end
      def api_secret; @@api_secret || Coolsms.api_secret end

      def conn=(conn)
        @conn = conn
      end

      def conn
        @conn ||= Faraday.new(url: url) do |conn|
          conn.response :json
          conn.request :instrumentation
          conn.adapter Coolsms.faraday_adapter || Faraday.default_adapter
        end
      end
    end

    def conn
      self.class.conn
    end

    def call
      raise Unimplemented, {desc: self.class.name}
    end

    def callback
      # do not call response, use @response
    end

    def auth_params
      timestamp = Time.now.to_i
      salt = SecureRandom.hex
      hmac_data = timestamp.to_s + salt.to_s
      signature = OpenSSL::HMAC.hexdigest('md5', self.class.api_secret, hmac_data)
      {
        api_key:    self.class.api_key,
        timestamp:  timestamp,
        salt:       salt,
        signature:  signature
      }
    end

    def to_params
      auth_params
    end

    def to_query
      to_params.to_query
    end

    def response
      @response ||= call
      callback
      @response
    rescue Oj::ParseError
      raise Coolsms::RestApi::InvalidJson, api: self
    rescue Faraday::Error::ClientError => e
      raise Coolsms::RestApi::ResponseError, {api: self, response: e}
    rescue Coolsms::RestApi::Error => e
      e.api = self
      raise e
    rescue
      raise Coolsms::RestApi::Error, api: self
    end
  end
end

require 'coolsms/rest_api/errors'
require 'coolsms/rest_api/faraday_error_handler'
require 'coolsms/rest_api/send'
require 'coolsms/rest_api/sent'
