module Coolsms
  class Message
    attr_reader :api
    attr_accessor :from, :text

    class EmptyMessage < Coolsms::Error; end
    class AlreadySent < Coolsms::Error; end

    def from
      @from || Coolsms.default_from
    end

    def send(*to)
      raise EmptyMessage if text.blank?
      raise AlreadySent if @api
      @api = Coolsms::RestApi::Send.new(text, from ,to)
      @api.call
    end

    def response
      api.response
    end

    def group
      Coolsms::Group.new(response.body['group_id'])
    end
  end
end
