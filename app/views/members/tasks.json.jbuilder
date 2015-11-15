json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description
  json.url project_task_url(task.project_id, task, format: :json)
end
