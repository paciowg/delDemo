module DetailHelper

    def getItemByID(itemContainer, id)
        return nil if itemContainer.item.blank? 
        itemContainer.item.each do |item|
            return item if item.linkId && item.linkId.eql?(id)
            childItems = getItemByID(item, id) 
            return childItems if childItems
        end
        nil
    end

end
