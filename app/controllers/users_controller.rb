class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]

    if @user.save
      redirect_to root_url, :notice => I18n.t('flash.signup.success')
    else
      render :new
    end
  end
end 
