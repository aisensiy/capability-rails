class LeaveRequestsController < ApplicationController
  # before_action :set_leave_request, only: [:show, :edit, :update, :destroy]
  before_filter :set_member

  # GET /leave_requests
  # GET /leave_requests.json
  def index
    @leave_requests = @member.leave_requests.all
  end

  # GET /leave_requests/1
  # GET /leave_requests/1.json
  def show
    @leave_request = @member.leave_requests.find(params[:id])
    if @leave_request.nil?
      render status: 404, nothing: true and return
    end
  end

  # GET /leave_requests/new
  def new
    @leave_request = LeaveRequest.new
  end

  def processed
    @leave_request = @member.leave_requests.find(params[:id])
    if @leave_request.nil?
      render status: 404, nothing: true and return
    end

    if current_user != @member.assign
      render status: 403, nothing: true and return
    end

    if params[:approved]
      @leave_request.approved!
    elsif params[:rejected]
      @leave_request.rejected!
    else
      render status: 400, nothing: true and return
    end

    render status: 200, nothing: true
  end

  # POST /leave_requests
  # POST /leave_requests.json
  def create
    @member = Member.find(params[:member_id])
    if @member != current_user
      render status: 403, nothing: true and return
    end
    @leave_request = @member.leave_requests.build(leave_request_params)

    if @leave_request.save
      render :show, status: :created, location: member_leave_request_url(@member, @leave_request)
    else
      render status: 400, nothing: true
    end
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
    if @member != current_user && @member.assign != current_user
      render status: 403, nothing: true and return
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def leave_request_params
    params.require(:leave_request).permit(:from, :to, :title)
  end
end
