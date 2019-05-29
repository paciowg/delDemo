require 'sequel'
require 'json'
require 'csv'

# DB = Sequel.connect('https://impact-fhir.mitre.org/r4')

# TODO
# I know this is not how we should be getting DEL questions
# I'm going with this for now to move on to the rest of the webapp
# I look forward to circling back to this so it's done correctly
class GetAssessments #< Sequel::Model
    # def self.getAssessmentSQL
    #     sql = `
    #         select 
    #             asmt_shrt_name as id,
    #             asmt_shrt_name as name,
    #             asmt_name as title,
    #             asmt_desc as description,
    #             creat_ts as date
    #         from del_data.asmt`
    #     DB[sql].all
    # end

    # def self.geAssessmentJSON
    #     sqlReply = getAssessmentSQL()
    #     hashes = sqlReply.collect { |sql|
    #         sql.to_hash
    #     }
    #     JSON.generate(hashes)
    # end

    def self.getAssessments
        assessments = CSV.read("storage/Data_Elements.csv")
        keys = assessments[0]
        assessments = assessments.drop(1)
        return sanitizeQuestions(assessments.map{ |values| Hash[ keys.zip(values)]})
    end

    # TODO
    # While this may be necessary, the questions' formats are inconsistent so currently on back-burner
    def self.sanitizeQuestions(assessments)
        return assessments
    end

end