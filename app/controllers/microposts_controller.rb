class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    
    if @micropost.save
      flash[:success] = 'post your message'
      redirect_to root_url
    else
      flash[:danger] = 'failed to post your message'
      render 'toppages/index'
    end
    
  end

  def destroy
    @micropost.destroy
    flash[:success] = "delete your message"
    redirect_back(fallback_location: root_path)
  end
  
  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    #消そうとしているメッセージが本当にこのユーザーのものなんかの検証
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
  
end
