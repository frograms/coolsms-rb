module Coolsms
  class Message < Base
    attr_reader :send_api, :send_response

    STATUSES = {
        :accepted => '0',
        :sending => '1',
        :reported => '2'
    }
    INVERTED_STATUSES = STATUSES.invert

    class EmptyMessage < Coolsms::Error; end
    class AlreadySent < Coolsms::Error; end

    def initialize(attrs_hash = {})
      @attributes = {}.with_indifferent_access
      assign_data(attrs_hash)
    end

    def from=(val); attributes[:from] = val end
    def from; attributes[:from] || Coolsms.default_from end

    def text=(val); attributes[:text] = val end

    def api
      return @api if @api
      raise Uninitialized, 'Message id not defined' if attributes[:id].blank?
      @api = Coolsms::RestApi::Sent.new
      @api.mid = id
      @api
    end

    def send(*to)
      raise EmptyMessage if text.blank?
      raise AlreadySent if @send_api || retrieved
      if self[:text].bytes.size <= 90
        @send_api = Coolsms::RestApi::Send.new(self[:text], from ,to)
      else
        @send_api = Coolsms::RestApi::Send.new(self[:text], from, to)
        @send_api.type = :LMS
      end
      @send_response = @send_api.call
      attributes[:group_id] = send_response.body['group_id']
      @send_response
    end

    def assign_data(data_hash)
      data_hash = data_hash.with_indifferent_access
      data_hash[:accepted_at] = Coolsms::TIMEZONE.parse(data_hash.delete(:accepted_time)) if data_hash[:accepted_time]
      data_hash[:sent_at] = Coolsms::TIMEZONE.parse(data_hash.delete(:sent_time)) if data_hash[:sent_time]
      data_hash[:scheduled_at] = Coolsms::TIMEZONE.parse(data_hash.delete(:scheduled_time)) if data_hash[:scheduled_time]
      data_hash[:status] = INVERTED_STATUSES[data_hash[:status]]
      attributes.update(data_hash)
    end

    def retrieve
      @response = api.call
      data = (@response.body[:data] && @response.body[:data].first) || {}
      assign_data(data)
      super
    end

    def group
      Coolsms::Group.new(group_id)
    end

    def type; self[:type] end
    def accepted_at; self[:accepted_at] end
    def recipient_number; self[:recipient_number] end
    def group_id; self[:group_id] end
    def result_code; self[:result_code] end
    def result_message; self[:result_message] end
    def sent_at; self[:sent_at] end
    def text; self[:text] end
    def carrier; self[:carrier] end
    def scheduled_at; self[:scheduled_at] end
    def status; self[:status] end
  end
end
