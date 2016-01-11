module Coolsms
  class Group
    attr_reader :id, :conditions_hash

    def initialize(id, conditions_hash = {})
      @id = id
      @arr = []
      @conditions_hash = conditions_hash.with_indifferent_access
    end

    def page(num)
      @arr[num] ||= Finder.new(conditions_hash.merge(group_id: id))
    end

    def all
      return @all if @all
      recursive_next(1)
      @all = @arr.map(&:data).flatten
    end

    def first
      page(1).data.first
    end

    private

    def recursive_next(num)
      n = page(num).retrieve
      recursive_next(num + 1) if n.has_next?
    end
  end
end
