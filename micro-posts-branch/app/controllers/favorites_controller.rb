class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  def create
    ##micropost.idの受け取り方が懸念
    post = Micropost.find(params[:post_id])
    current_user.favorite(post)
    flash[:success] = 'いいね！しました'
    redirect_to root_path
  end

  def destroy
    post = Micropost.find(params[:post_id])
    current_user.unfavorite(post)
    flash[:success] = 'いいね！解除しました'
    redirect_to root_path
  end
end
