json.array!(@exam_papers) do |exam_paper|
  json.extract! exam_paper, :id, :name, :description
  json.url tag_exam_paper_url(@tag, exam_paper)
end
