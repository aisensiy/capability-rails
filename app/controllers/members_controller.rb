class MembersController < ApplicationController
  respond_to :json
  before_filter :authenticate, except: [:login]

  def tasks
    @tasks = Event.task_for_member(params[:id])
  end

  def show
    @member = Member.find(params[:id])
    if @member.nil?
      render status: :not_found, nothing: true
    end
  end

  def index
    @members = Member.all
  end

  def assigned
    authorize! :assigned, Member.new
    employee = Member.find(params[:id])
    manager = Member.where(id: params[:manager_id], role: :manager).first
    if manager.nil? || employee.nil?
      render status: 404, nothing: true
    else
      employee.assign_to manager
      render nothing: true, status: 200
    end
  end

  def create
    authorize! :create, Member.new
    @member = Member.new member_params
    if @member.save
      render nothing: true, status: :created, location: @member
    else
      render nothing: true, status: 400
    end
  end

  def login
    member = Member.find_by(name: login_params[:name])
    if member && member.authenticate(login_params[:password])
      session[:user_id] = member.id
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  def logout
    session[:user_id] = nil
    render nothing: true, status: 200
  end

  private
  def member_params
    params.require(:member).permit(:name, :password, :role)
  end

  def login_params
    params.permit(:name, :password)
  end
end