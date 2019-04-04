module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in_user
    unless logged_in?
      flash[:info] = 'Please log in.'
      redirect_to login_url
    end
  end

  def logged_in_as_admin?
    unless current_user&.admin?
      flash.now[:error] = 'Insufficient privileges!'
      redirect_to todos_path
    end
  end
end
