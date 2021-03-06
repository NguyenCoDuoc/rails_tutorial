class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :destroy]
  before_action :admin_user, only: :destroy
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.users.page.number_member_user
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.users.page.number_member_micropost
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".error_create_user"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash.now[:error] = t ".error_delete"
    end
    redirect_to users_url
  end

  def following
    @title = t ".following"
    @users = @user.following.paginate  page: params[:page],
      per_page: Settings.users.page.number_member_following
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @users = @user.followers.paginate  page: params[:page],
      per_page: Settings.users.page.number_member_followers
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    return if @user.is_user? current_user
    flash[:danger] = t ".error_correct"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?
    flash[:danger] = t ".error_not_admin"
    redirect_to root_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    render file: "public/404.html", status: :not_found, layout: false
  end
end
