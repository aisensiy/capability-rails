class TimecardsController < ApplicationController
  # before_action :set_timecard, only: [:show, :edit, :update, :destroy]
  before_filter :set_member, only: [:show, :index]

  # GET /timecards
  # GET /timecards.json
  def index
    @timecards = @member.timecards.all
  end

  # GET /timecards/1
  # GET /timecards/1.json
  def show
    @timecard = @member.timecards.find(params[:id])
    if @timecard.nil?
      render status: 404, nothing: true and return
    end
  end

  # GET /timecards/new
  def new
    @timecard = LeaveRequest.new
  end

  # POST /timecards
  # POST /timecards.json
  def create
    unless current_user.system?
      render status: 403, nothing: true and return
    end

    @member = Member.find(params[:member_id])
    @timecard = @member.timecards.build(timecard_params)

    if @timecard.save
      render nothing: true, status: :created, location: member_timecard_url(@member, @timecard)
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


  # Never trust parameters from the scary internet, only allow the white list through.
  def timecard_params
    params.require(:timecard).permit(:hour, :date)
  end
end
