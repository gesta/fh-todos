require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  def default_attributes
    {
      completed?: false,
      content: 'sample',
      priority: 42,
      due_date: Date.new(1999, 1, 25)
    }
  end

  def build(extra = {})
    Todo.new(default_attributes().merge(extra))
  end

  test 'completed? has to be boolean' do
    assert build({completed?: true}).valid?
    assert build({completed?: false}).valid?

    todo = build({completed?: nil}).tap(&:validate)
    assert todo.errors.full_messages == ['Completed?  is not true or false']
  end

  test 'content has to be provided' do
    todo = build({content: ''}).tap(&:validate)
    assert todo.errors.full_messages == ["Content can't be blank"]
  end

  test 'content has to be no more than 200 characters' do
    assert build({content: 'a' * 200}).valid?

    todo = build({content: 'a' * 201}).tap(&:validate)
    assert todo.errors.full_messages == ["Content has to be up to 200 characters"]
  end

  test 'due_date has to be provided' do
    todo = build({due_date: nil}).tap(&:validate)
    assert todo.errors.full_messages == ["Due date can't be blank"]
  end

  test 'priority has to be provided' do
    todo = build({priority: nil}).tap(&:validate)
    assert todo.errors.full_messages == ["Priority is not a number"]
  end

  test 'priority has to be at least 1' do
    assert build({priority: 1}).valid?

    todo = build({priority: 0}).tap(&:validate)
    assert todo.errors.full_messages == ['Priority must be greater than or equal to 1']
  end
end
