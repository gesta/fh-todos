require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'load sign up' do
    get signup_url
    assert_response :success
    assert_template 'users/new'
  end

  test 'create user and sign in' do
    get login_url
    post users_url, params: {user: default_user_attributes()}
    follow_redirect!
    assert flash[:info] == 'Welcome and please populate your todo list.'
    assert_template 'todos/index'
    empty_flash?
  end

  test 'root renders /todos' do
    get '/'
    follow_redirect!
    assert_template 'todos/index'
  end
end
