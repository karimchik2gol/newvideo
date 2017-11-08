class VideosController < ApplicationController
  skip_before_filter :check_user, only: [:success]

  ITEMS_PER_PAGE = 16

  # GET SUCCESS
  def success
  end
  

  def index
    @videos = current_user.videos.order("views DESC").limit(ITEMS_PER_PAGE)
    @categories = current_user.videos.group_by(&:category_id).map { |f| Category.find_by_category_id(f[0]) }
    @videos = @videos.where(category_id: params[:category_id].to_i) if params[:category_id]
  end

  def newitems
    @videos = current_user.videos.order("views DESC").offset(params[:page].to_i * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    right = ITEMS_PER_PAGE - @videos.count > 0 ? false : true
    response.headers['permit_to_scroll'] = "#{right}"
    render partial: "video_list"
  end

  def get_video_info
    # Set last categories for user
    if current_user.my_category
      current_user.my_category.set_new_categories(params[:category_ids])
    else
       current_user.build_my_category(list_categories: params[:category_ids].join(",")).save
    end
    
    # THANK YOU TO MY FRIENDS HEROKU
    # I CANT DEPLOY FUCKING APP, BECAUSE OF GREEDY REDIS
    # THANK YOU!!!!!  
    #YoutubeTrendsWorker.perform_async(params, session[:user_id])
    Video.parse_trends(params, session[:user_id])
    #Video.parse_trends(params, session[:user_id])
    redirect_to videos_path
  end

  def parse_trends
    myCat = current_user.my_category
    @categories = myCat ? myCat.list_categories : []
  end

  def destroy
    if params[:category_id]
      videos = current_user.videos.where(category_id: params[:category_id].to_i)
    else
      videos = current_user.videos
    end
    videos.destroy_all
    redirect_to videos_path
  end
  
end
