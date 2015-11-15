class ExamRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, default: "created"
  field :exam_time, type: Time
  field :tag_id, type: String

  embedded_in :member

  validates_presence_of :tag_id, :exam_time
  validates_inclusion_of :status, in: [:created, :confirmed, :rejected, :finished, :started, :cancelled]
end
