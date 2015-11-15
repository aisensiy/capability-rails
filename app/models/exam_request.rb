class ExamRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, default: "created"
  field :exam_time, type: Time
  field :tag_id, type: String

  embedded_in :member

  validates_presence_of :tag_id, :exam_time
  validates_inclusion_of :status, in: %w(created confirmed rejected finished started cancelled)

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

    self.status = state
    true
  end
end
