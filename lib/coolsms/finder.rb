module Coolsms
  class Finder < Base
    def initialize(conditions_hash = {})
      @attributes = conditions_hash.with_indifferent_access
    end

    def page=(num)
      attributes[:page] = num
    end

    def api
      @api = Coolsms::RestApi::Sent.new
      @api.count = attributes[:per]
      @api.page = attributes[:page]
      @api.rcpt = attributes[:recipient_number]
      @api.start = attributes[:accepted_from]
      @api.end = attributes[:accepted_to]
      @api.status = attributes[:status]
      @api.resultcode = attributes[:result_code]
      @api.notin_resultcode = attributes[:not_in_result_code]
      @api.mid = attributes[:message_id]
      @api.gid = attributes[:group_id]
      @api
    end

    def retrieve
      @response = api.call
      attributes.update(@response.body.with_indifferent_access)
      attributes[:data].map! do |msg_hash|
        msg_hash[:id] = msg_hash.delete(:message_id)
        Coolsms::Message.new(msg_hash)
      end
      super
    end

    def data; self[:data] end
    def list_count; self[:list_count] end
    def total_count; self[:total_count] end
    def page; self[:page] end

    def has_next?
      (((page - 1) * list_count) + data.size) < total_count
    end

    def has_prev?
      page > 1
    end

    alias_method :__dupp, :dup
    def dup
      duplicated = __dupp
      duplicated.instance_variable_set(:@response, nil)
      duplicated.instance_variable_set(:@retrieved, nil)
      duplicated
    end

    def next_page
      finder = self.dup
      finder.page = page + 1
      finder
    end
  end
end
