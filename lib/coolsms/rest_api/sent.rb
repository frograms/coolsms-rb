module Coolsms
  class RestApi::Sent < RestApi
    OPTIONAL_PARAMS = [
        :count,
        :page,
        :rcpt,
        :start,
        :end,
        :status,
        :resultcode,
        :notin_resultcode,
        :mid,
        :gid
    ]

    attr_accessor *OPTIONAL_PARAMS

    def to_params
      params = auth_params
      OPTIONAL_PARAMS.each do |param|
        params.update(param => send(param)) if send(param)
      end
      params
    end

    def call
      conn.get '/sms/1.5/sent', to_params
    end
  end
end
