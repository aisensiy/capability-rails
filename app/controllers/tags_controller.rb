class TagsController < ApplicationController
  before_filter :authenticate
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
    if @tag.nil?
      render status: 404, nothing: true and return
    end
  end

  # POST /tags
  # POST /tags.json
  def create
    authorize! :create, Tag.new
    @tag = Tag.new(tag_params)

    if @tag.save
      render nothing: true, status: :created, location: tag_url(@tag)
    else
      render status: 400, nothing: true
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
