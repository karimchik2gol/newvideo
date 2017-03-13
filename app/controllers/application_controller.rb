class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_filter :check_user

  def check_user
    redirect_to root_url unless session[:user_id]
  end

  def super_admin
    redirect_to root_url unless current_user.is_super_admin?
  end
  
end
