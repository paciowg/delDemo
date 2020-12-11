class QItem

    attr_reader :item
    attr_reader :level

    def initialize(item, level=0)
        @item = item
        @level = level
    end

end