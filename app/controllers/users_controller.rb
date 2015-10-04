class UsersController < ApplicationController
  authorize_resource :user

  def destroy
    user.destroy
    render :index
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
    @user ||= User.find_by_uid(params[:id])
  end
  helper_method :user

  def users
    @users ||= User.with_external
  end
  helper_method :users
end