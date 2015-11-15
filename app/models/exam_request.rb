class ExamRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, default: "created"
  field :exam_time, type: Time
  field :tag_id, type: String
  field :exam_paper_id, type: String
  field :grade, type: Integer

  embedded_in :member

  validates_presence_of :tag_id, :exam_time
  validates_inclusion_of :status, in: %w(created confirmed rejected finished started cancelled)

  def tag
    Tag.find(self.tag_id)
  end

  def change_state(state, *options)
    state = state.to_sym

    valid_state_transform = {
        created: [:rejected, :confirmed],
        rejected: [],
        confirmed: [:cancelled, :started],
        started: [:finished],
        cancelled: [],
        finished: []
    }

    return false if valid_state_transform[self.status.to_sym].size == 0

    valid_state = valid_state_transform[self.status.to_sym]
    unless valid_state.include?(state)
      return false
    end

    self.status = state.to_s
    true
  end
end
