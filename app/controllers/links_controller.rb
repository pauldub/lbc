class LinksController < ApplicationController
  before_filter :require_login

  load_and_authorize_resource :parent => :search

  def fetch
    link = Link.find(params[:id])

    Delayed::Job.enqueue FetchLinkJob.new(link.id)

    redirect_to :back
  end

  def like
    @link = Link.find(params[:id])

    flash[:error] = t('flash.like.failure') unless current_user.like(@link)

    redirect_to :back
  end

  def dislike
    @link = Link.find(params[:id])

    flash[:error] = t('flash.dislike.failure') unless current_user.dislike(@link)

    redirect_to :back
  end

  def bookmark
    @link = Link.find(params[:id])

    flash[:error] = t('flash.bookmark.failure') unless current_user.bookmark(@link)

    redirect_to :back
  end

  def remove_bookmark
    @link = Link.find(params[:id])

    flash[:error] = t('flash.remove_bookmark.failure') unless current_user.unbookmark(@link)

    redirect_to :back
  end

  def hide
    @link = Link.find(params[:id])

    flash[:error] = t('flash.hide.failure') unless current_user.hide(@link)

    redirect_to :back
  end
end
