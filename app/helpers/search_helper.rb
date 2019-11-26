module SearchHelper

    def searchItems(qs, term)
        items = Hash.new
        unless qs.nil?
            qs.each do |q|
                key = q.name.gsub("MDS3_0", "MDS3.0").gsub("_", " ") + " (v." + q.version + ")"
                items[key] = relevantItems(q.item, term)
            end
            items.delete_if{ |key, value| value.blank? }
        end
        pageItems(items, 100)
    end

    def relevantItems(items, term)
        term = "" if term.nil?
        chosen = []
        items.each do |item|
            chosen.push(item) if item.text.present? && item.prefix.present? && item.text.upcase.include?(term.upcase)
            chosen += relevantItems(item.item, term) if item.item.present?
        end
        chosen
    end

    def pageItems(items, pageSize)
        pagedItems = Array.new
        itemCount = 0
        items.each do |assessment, itemArray|
            if itemArray.length < pageSize - (itemCount % pageSize)
                if pagedItems[itemCount / pageSize].nil?
                    pagedItems[itemCount / pageSize] = { assessment => itemArray }
                else
                    pagedItems[itemCount / pageSize][assessment] = itemArray
                end
                itemCount += itemArray.length
            else
                itemArray.each do |item|
                    if pagedItems[itemCount / pageSize].nil?
                        pagedItems[itemCount / pageSize] = { assessment => [item] }
                    else
                        if pagedItems[itemCount / pageSize][assessment].nil?
                            pagedItems[itemCount / pageSize][assessment] = [item]
                        else
                            pagedItems[itemCount / pageSize][assessment].push(item)
                        end
                    end
                    itemCount += 1
                end
            end
        end
        [itemCount, pagedItems]
    end

end
