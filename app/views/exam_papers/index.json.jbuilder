json.array!(@exam_papers) do |exam_paper|
  json.extract! exam_paper, :id, :index, :create, :show
  json.url exam_paper_url(exam_paper, format: :json)
end
