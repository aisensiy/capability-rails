class ExamRequestsController < ApplicationController
  # before_action :set_exam_request, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate
  before_filter :set_member

  # GET /exam_requests
  # GET /exam_requests.json
  def index
    @exam_requests = @member.exam_requests.all
  end

  # GET /exam_requests/1
  # GET /exam_requests/1.json
  def show
    @exam_request = @member.exam_requests.find(params[:id])
    if @exam_request.nil?
      render status: 404, nothing: true and return
    end
  end

  def processed
    @exam_request = @member.exam_requests.find(params[:id])
    if @exam_request.nil?
      render status: 404, nothing: true and return
    end

    unless current_user.admin?
      render status: 403, nothing: true and return
    end

    if @exam_request.change_state params[:state]
      if params[:state] == 'started'
        @exam_paper = @exam_request.tag.exam_papers.find(params[:exam_paper_id])
        if @exam_paper.nil?
          render status: 400, nothing: true and return
        end
        @exam_request.exam_paper_id = params[:exam_paper_id]
      end

      if params[:state] == 'finished'
        grade = params[:grade]
        if grade.nil?
          render status: 400, nothing: true and return
        end
        @exam_request.grade = grade
      end

      @exam_request.save
      render status: 200, nothing: true
    else
      render status: 400, nothing: true
    end
  end

  # POST /exam_requests
  # POST /exam_requests.json
  def create
    @member = Member.find(params[:member_id])
    if @member != current_user
      render status: 403, nothing: true and return
    end
    @exam_request = @member.exam_requests.build(exam_request_params)
    if @exam_request.save
      render :show, status: :created, location: member_exam_request_url(@member, @exam_request)
    else
      render status: 400, nothing: true
    end
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
    if @member != current_user && !current_user.admin?
      render status: 403, nothing: true and return
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def exam_request_params
    params.require(:exam_request).permit(:exam_time, :tag_id)
  end
end
