class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    render nothing: true, status: 403
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  def current_user
    @current_user ||= Member.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate
    render nothing: true, status: 401 if current_user.nil?
  end
end
