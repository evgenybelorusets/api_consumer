class ApplicationController < ActionController::Base
  PERMITTED_DEVISE_PARAMS = [ :first_name, :last_name, :email, :password, :password_confirmation, :current_password ]
  DEVISE_ACTIONS_WITH_ADDITIONAL_PARAMS = [ :sign_up, :account_update ]

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_uid

  rescue_from CanCan::AccessDenied do
    redirect_to root_url
  end

  rescue_from 'ActiveResource::ForbiddenAccess' do |exception|
    log_exception(exception)
    head :forbidden
  end

  rescue_from 'ActiveResource::ResourceNotFound' do |exception|
    log_exception(exception)
    head :not_found
  end

  rescue_from 'ActiveResource::ResourceInvalid' do |exception|
    log_exception(exception)
    head :unprocessable_entity
  end

  protected

  def set_user_uid
    BaseResource.user_uid = current_user.uid
  end

  def current_user
    @current_user ||= super || User.guest.new
  end

  def log_exception(exception)
    Rails.logger.error(exception.to_s)
    exception.backtrace.each { |line| Rails.logger.error(line) }
  end

  def configure_permitted_parameters
    DEVISE_ACTIONS_WITH_ADDITIONAL_PARAMS.each do |action|
      devise_parameter_sanitizer.for(action) { |u| u.permit(*PERMITTED_DEVISE_PARAMS) }
    end
  end
end
