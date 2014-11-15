class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorize
    unless current_user.try(:admin)
      flash[:notice] = 'You must be an admin to add job listings.'
      redirect_to jobs_path
    end
  end
end
