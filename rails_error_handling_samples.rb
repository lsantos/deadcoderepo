# coding: utf-8
class ApplicationController < ActionController::Base
  # Catch all exceptions at a stretch
  rescue_from Exception, :with => :handle_exceptions

private

  # Handle exceptions
  def handle_exceptions(e)
    case e

    # Handling exception of CanCan gem
    when CanCan::AccessDenied
      authenticate_user!

    # Handling exception when record not found
    when ActiveRecord::RecordNotFound
      not_found

    # Or handle any other exceptions
    else
      internal_error(e)
    end
  end

  def not_found
    # Render 404 error page
    render 'application/not_found', :status => 404
  end

  def internal_error(exception)
    if RAILS_ENV == 'production'
      # Here you can send e-mail to developer or notify Hoptoad
      # ...

      # Render a pretty page for production with an error message
      render :layout   => 'layouts/internal_error',
             :template => 'application/internal_error',
             :status   => 500
    else
      # Forward exception that we were able to see a standard error page with stack for development.
      # With no arguments, it re-raises the recent exception.
      raise
    end
  end
end


if (Rails.env.production?)
  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,
              ActionController::UnknownController,
              ActionController::UnknownAction, :with => :render_404
  rescue_from NoMethodError, RuntimeError, :with => :render_500
end

def render_404
   render :template => "/shared/404", 
          :layout => 'application', 
          :status => :not_found
 end

 def render_500
   render :template => "/shared/505", 
          :layout => 'application', 
          :status => :internal_server_error
 end