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
        items
    end

    def relevantItems(items, term)
        chosen = []
        items.each do |item|
            chosen.push(item) if item.text.present? && item.prefix.present? && item.text.upcase.include?(term.upcase)
            chosen += relevantItems(item.item, term) if item.item.present?
        end
        chosen
    end

end
