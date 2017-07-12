class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_user_follow, only: :destroy

  def create
    if current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".can_not_follow_user"
      call_back
    end
  end

  def destroy
    if current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".can_not_follow_user"
      call_back
    end
  end

  private

  def call_back
    redirect_back fallback_location: root_path
  end

  def load_user
    @user = User.find_by id: params[:followed_id]
    render_404 unless @user
  end

  def load_user_follow
    @user_relation = Relationship.find params[:id]
    @user_relation ? @user = @user_relation.followed : render_404
  end
end
