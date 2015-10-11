class UsersController < ApplicationController
  authorize_resource :user

  def destroy
    user.destroy
    redirect_to users_url
  end

  def update
    if user.update_attributes(user_params)
      redirect_to users_url
    else
      render :edit
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def user
    @user ||= User.find_by(uid: params[:id])
  end
  helper_method :user

  def users
    @users ||= User.page(params[:page])
  end
  helper_method :users
end