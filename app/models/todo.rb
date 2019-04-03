class Todo < ApplicationRecord
  validates :completed?, inclusion: { in: [true, false], message: "%{value} is not true or false" }
  validates :content, presence: true,
            length: {maximum: 200, too_long: 'has to be up to %{count} characters'}
  validates :due_date, presence: true
  validates :priority, numericality: {allow_nil: false, only_integer: true, greater_than_or_equal_to: 1}
end
