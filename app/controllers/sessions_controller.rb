class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params.dig(:session, :email).downcase)
    if user&.authenticate(params.dig(:session, :password))
      log_in user
      flash[:info] = "You've successfuly logged in."
      redirect_to todos_path
    else
      flash.now[:error] = 'Invalid email or password!'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:info] = "You've successfuly logged out."
    redirect_to todos_path
  end
end
