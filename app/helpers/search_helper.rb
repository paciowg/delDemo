module SearchHelper

    def searchItems(qs, term)
        items = Hash.new
        unless qs.nil?
            qs.each do |q|
                items[q.name.sub("MDS30", "MDS3.0") + " (v." + q.version + ")"] = relevantItems(q.item, term)
            end
            items.keep_if{ |key, value| value.present? }
        end
        items
    end

    def relevantItems(items, term)
        chosen = []
        items.each do |item|
            chosen.push(item) if item.text.upcase.include?(term.upcase) && item.prefix.present?
            chosen += relevantItems(item.item, term) if item.item.present?
        end
        chosen
    end

end
