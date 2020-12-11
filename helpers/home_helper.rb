module HomeHelper
    
    def populateSummaryHash(summaryArray)
        sumHash = Hash.new
        summaryArray.each do |sum|
            asmt = sum[:assessment]
            category = sum[:name].split(" ")[-2]
            sumHash[asmt] = Hash.new unless sumHash.has_key?(asmt)
            sumHash[asmt][category] = Array.new unless sumHash[asmt].has_key?(category)
            sumHash[asmt][category].push(sum)
        end
        sumHash
    end

end
