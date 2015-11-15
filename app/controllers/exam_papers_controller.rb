class ExamPapersController < ApplicationController
  # before_action :set_exam_paper, only: [:show, :edit, :update, :destroy]
  before_filter :set_tag, only: [:show, :index]

  # GET /exam_papers
  # GET /exam_papers.json
  def index
    @exam_papers = @tag.exam_papers.all
  end

  # GET /exam_papers/1
  # GET /exam_papers/1.json
  def show
    @exam_paper = @tag.exam_papers.find(params[:id])
    if @exam_paper.nil?
      render status: 404, nothing: true and return
    end
  end

  # GET /exam_papers/new
  def new
    @exam_paper = LeaveRequest.new
  end

  # POST /exam_papers
  # POST /exam_papers.json
  def create
    unless current_user.admin?
      render status: 403, nothing: true and return
    end

    @tag = Tag.find(params[:tag_id])
    @exam_paper = @tag.exam_papers.build(exam_paper_params)

    if @exam_paper.save
      render nothing: true, status: :created, location: tag_exam_paper_url(@tag, @exam_paper)
    else
      render status: 400, nothing: true
    end
  end

  private

  def set_tag
    @tag = tag.find(params[:tag_id])
    if @tags.nil?
      render status: 404, nothing: true and return
    end
    unless current_user.admin?
      render status: 403, nothing: true and return
    end
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def exam_paper_params
    params.require(:exam_paper).permit(:name, :description)
  end
end
