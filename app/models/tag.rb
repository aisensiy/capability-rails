class Tag
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  validates_presence_of :description, :name

  embeds_many :exam_papers
end
