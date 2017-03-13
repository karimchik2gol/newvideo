class EnterController < ApplicationController
  skip_before_filter :check_user

  def login
    if session[:user_id]
      redirect_to "/videos"
    else
      render layout: "enter"
    end
  end

  def check
    user = User.find_by_email(params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/videos"
    else
      redirect_to request.referrer
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
