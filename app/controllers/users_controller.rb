class UsersController < ApplicationController
  
  before_action :require_user_logged_in, only:[:index, :show]
  
  def index
    #全UserをID降順に並べる。ページネーションで25件ずつ
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "sign up!"
      redirect_to @user
    else
      flash.now[:danger] = "failed to sign up..."
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
