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
end

class ActiveSupport::TestCase
  include UserTestHelper
end
