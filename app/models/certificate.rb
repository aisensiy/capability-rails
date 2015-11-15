class Certificate
  include Mongoid::Document
  include Mongoid::Timestamps
  field :tag_id, type: String
  field :exam_id, type: String

  embedded_in :member
end
