module Coolsms
  class RestApi
    class FaradayErrorHandler < Faraday::Middleware
      # Override this to modify the environment after the response has finished.
      # Calls the `parse` method if defined
      def call(env)
        @app.call(env).on_complete do |response_env|
          check_error!(env)
        end
      end

      def check_error!(env)
        # env.body = parse(env.body) if respond_to?(:parse) && env.parse_body?
        raise Coolsms::RestApi::InvalidResultCode, m: "#{env.body['errorCode']} #{env.body['errorMessage']}", response: env if env.body['result_code'] != '00'
      end
    end
  end
end
