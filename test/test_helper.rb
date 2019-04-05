ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

module UserTestHelper
  def default_user_attributes
    {
      admin?: false,
      email: 'test@ema.il',
      password: 'simpler',
      password_confirmation: 'simpler'
    }
  end

  def build_user(extra = {})
    User.new(default_user_attributes().merge(extra))
  end

  def create_user(extra = {})
    build_user(extra).tap(&:save!)
  end

  def default_todo_attributes
    {
      completed?: false,
      content: 'sample',
      priority: 42,
      due_date: Date.new(1999, 1, 25)
    }
  end

  def build_todo(extra = {})
    Todo.new(default_todo_attributes().merge(extra))
  end

  def create_todo(extra = {})
    build_todo(extra).tap(&:save!)
  end
end

module SessionsTestHelper
  def log_in(user_attributes = {}, login_attributes = {})
    User.create(default_user_attributes().merge(user_attributes))
    user_session = default_user_attributes().slice(:email, :password).merge(login_attributes)
    post login_path, params: {session: user_session}
  end
end

class ActionDispatch::IntegrationTest
  include UserTestHelper
  include SessionsTestHelper

  def empty_flash?
    get '/'
    assert flash.empty?
  end
end

class ActiveSupport::TestCase
  include UserTestHelper
end
