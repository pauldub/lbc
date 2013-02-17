class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:user][:username], params[:user][:password], false)
    if user
      redirect_back_or_to root_url, :notice => I18n.t('flash.login.success')
    else
      flash.now.alert = I18n.t('flash.login.failure')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => I18n.t('flash.logout.success')
  end
end
