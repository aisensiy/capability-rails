class CertificatesController < ApplicationController
  # before_action :set_certificate, only: [:show, :edit, :update, :destroy]
  before_filter :set_member, only: [:show, :index, :create]

  # GET /certificates
  # GET /certificates.json
  def index
    @certificates = @member.certificates.all
  end

  # GET /certificates/1
  # GET /certificates/1.json
  def show
    @certificate = @member.certificates.find(params[:id])
    if @certificate.nil?
      render status: 404, nothing: true and return
    end

    @tag = Tag.find(@certificate.tag_id)
    @exam = @member.exam_requests.find(@certificate.exam_id)
  end

  # POST /certificates
  # POST /certificates.json
  def create
    unless current_user.admin?
      render status: 403, nothing: true and return
    end

    if certificate_params[:exam_id].nil? || certificate_params[:tag_id].nil?
      render status: 400, nothing: true and return
    end

    @exam = @member.exam_requests.find(certificate_params[:exam_id])
    @tag = Tag.find(certificate_params[:tag_id])

    if @exam.nil? || @tag.nil?
      render status: 400, nothing: true and return
    end

    @certificate = @member.certificates.build(certificate_params)

    if @certificate.save
      render nothing: true, status: :created, location: member_certificate_url(@member, @certificate)
    else
      render status: 400, nothing: true
    end
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
    if @member.nil?
      render status: 404, nothing: true
    end
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def certificate_params
    params.require(:certificate).permit(:exam_id, :tag_id)
  end
end
