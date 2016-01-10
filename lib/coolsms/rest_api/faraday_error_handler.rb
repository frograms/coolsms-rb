module Coolsms
  class RestApi
    class FaradayErrorHandler < Faraday::Response::Middleware
      # Override this to modify the environment after the response has finished.
      # Calls the `parse` method if defined
      def on_complete(env)
        # env.body = parse(env.body) if respond_to?(:parse) && env.parse_body?
        raise Coolsms::RestApi::InvalidResultCode, {response: env} if env.body['result_code'] != '00'
      end
    end
  end
end
