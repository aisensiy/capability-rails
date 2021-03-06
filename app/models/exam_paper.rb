class ExamPaper
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  embedded_in :tag

  validates_presence_of :name, :description
end
