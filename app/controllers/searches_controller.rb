class SearchesController < ApplicationController
  before_filter :require_login

  load_and_authorize_resource

  def index
  end

  def results
    @search = Search.find(params[:id])
    @results = @search.links.desc(:id).page params[:page]
  end

  def bookmarks
    @bookmarks = Link.where(:id.in => current_user.bookmarked_link_ids).desc(:id).page params[:page]
  end

  def likes
    @likes = Link.where(:id.in => current_user.liked_link_ids).desc(:id).page params[:page]
  end

  def recommendations
    @recommendations = current_user.recommended_links
    @similar_raters = current_user.similar_raters
  end

  def statistics
    @search = Search.find params[:id]
    authorize!(:read, @search || Search)
  end
  
  def show
  end

  def new
  end

  def create
    @search.user = current_user
    if @search.save
      redirect_to @search
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @search.update_attributes params[:search]
      respond_to do |format|
        format.html { redirect_to @search }
        format.json { render :json => @search }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render :json => @search }
      end
    end
  end

  def run
    @search = Search.find params[:id]
    authorize!(:run, @search || Search)

    Delayed::Job.enqueue SearchJob.new(@search.id) if @search

    redirect_to searches_url
  end

  def share
    @search = Search.find params[:id]
    authorize!(:share, @search || Search)

    user = User.find_by_email params[:user][:email]

    if user
      @search.users << user
    end

    redirect_to @search
  end
end
