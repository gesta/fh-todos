require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'load login' do
    get login_url
    assert_response :success
    assert_template 'sessions/new'
  end

  test 'log in' do
    log_in
    follow_redirect!
    assert flash[:info] == "You've successfuly logged in."
    assert_template 'todos/index'
    empty_flash?
  end

  test 'authenticate credentials' do
    log_in({}, {password: 'invalid'})
    assert flash[:error] == 'Invalid email or password!'
  end

  test 'log out' do
    log_in
    follow_redirect!
    delete logout_path
    follow_redirect!
    assert flash[:info] == "You've successfuly logged out."
    empty_flash?
  end
end
