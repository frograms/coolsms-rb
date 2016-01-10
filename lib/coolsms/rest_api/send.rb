module Coolsms
  class RestApi
    # http://www.coolsms.co.kr/SMS_API
    class Send < RestApi
      NECESSARY_PARAMS = [:from, :to, :text]
      OPTIONAL_PARAMS = [
        :type,
        :image, :image_encoding,
        :refname,
        :country,
        :datetime,
        :subject,
        :charset,
        :srk,
        :mode,
        :extension,
        :delay,
        :force_sms,
        :os_platform,
        :dev_lang,
        :sdk_version,
        :app_version
      ]

      attr_accessor *(NECESSARY_PARAMS + OPTIONAL_PARAMS)

      def initialize(text, from, *to)
        self.text = text
        self.from = Coolsms.number_strip(from)
        self.to = to
      end

      def to_params
        params = auth_params
        NECESSARY_PARAMS.each do |param|
          params = params.update(param => send(param))
        end
        OPTIONAL_PARAMS.each do |param|
          params = params.update(param => send(param)) if send(param)
        end

        to = Array(params[:to]).flatten
        to = to.map do |num|
          splited = num.split(',')
          splited.map { |num2| Coolsms.number_strip(num2) }
        end.flatten.uniq.join(',')
        params[:to] = to

        params
      end

      def call
        conn.post '/sms/1.5/send', to_query
      end
    end
  end
end
