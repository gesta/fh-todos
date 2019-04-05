require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test 'completed? has to be boolean' do
    assert build_todo({completed?: true}).valid?
    assert build_todo({completed?: false}).valid?

    todo = build_todo({completed?: nil}).tap(&:validate)
    assert todo.errors.full_messages == ['Completed?  is not true or false']
  end

  test 'content has to be provided' do
    todo = build_todo({content: ''}).tap(&:validate)
    assert todo.errors.full_messages == ["Content can't be blank"]
  end

  test 'content has to be no more than 200 characters' do
    assert build_todo({content: 'a' * 200}).valid?

    todo = build_todo({content: 'a' * 201}).tap(&:validate)
    assert todo.errors.full_messages == ["Content has to be up to 200 characters"]
  end

  test 'due_date has to be provided' do
    todo = build_todo({due_date: nil}).tap(&:validate)
    assert todo.errors.full_messages == ["Due date can't be blank"]
  end

  test 'priority has to be provided' do
    todo = build_todo({priority: nil}).tap(&:validate)
    assert todo.errors.full_messages == ["Priority is not a number"]
  end

  test 'priority has to be at least 1' do
    assert build_todo({priority: 1}).valid?

    todo = build_todo({priority: 0}).tap(&:validate)
    assert todo.errors.full_messages == ['Priority must be greater than or equal to 1']
  end
end
