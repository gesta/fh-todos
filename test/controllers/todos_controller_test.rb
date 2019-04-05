require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest
  def xhr_headers
    {'Accept': 'application/json'}
  end

  test 'lists todos' do
    todo = create_todo()
    get api_v1_todos_path, headers: xhr_headers()
    assert JSON.parse(response.body).map { |attributes| Todo.new(attributes) } == [todo]
  end

  test 'get todo' do
    log_in()
    todo = create_todo()
    get api_v1_todos_path + "/#{todo.id}", headers: xhr_headers()
    assert Todo.new(JSON.parse(response.body)) == todo
  end

  test 'create todo' do
    log_in()
    parameters = {todo: default_todo_attributes()}
    post api_v1_todos_path, headers: xhr_headers(), params: parameters
    assert_response :success
  end

  test 'fail to create todo with invalid parameters' do
    log_in()
    parameters = {todo: default_todo_attributes().merge({priority: 0})}
    post api_v1_todos_path, headers: xhr_headers(), params: parameters
    assert_response :bad_request
    assert JSON.parse(response.body) == {"priority" => ["must be greater than or equal to 1"]}
  end

  test 'update todo' do
    log_in()
    todo = create_todo()
    parameters = {todo: {priority: 24}}
    put api_v1_todos_path + "/#{todo.id}", headers: xhr_headers(), params: parameters
    assert :success
    assert todo.reload.priority == 24
  end

  test 'fail to update todo with invalid parameters' do
    log_in()
    todo = create_todo()
    parameters = {todo: {priority: 0}}
    put api_v1_todos_path + "/#{todo.id}", headers: xhr_headers(), params: parameters
    assert response.status == 400
    assert todo.reload.priority == 42
    assert JSON.parse(response.body) == {"priority" => ["must be greater than or equal to 1"]}
  end

  test 'destroy todo' do
    log_in(admin?: true)
    todo = create_todo()
    delete api_v1_todos_path + "/#{todo.id}", headers: xhr_headers()
    assert_response :success
    assert Todo.find_by_id(todo.id) == nil
  end

  test 'fail to destroy missing todo' do
    log_in(admin?: true)
    assert Todo.find_by_id(42) == nil
    delete api_v1_todos_path + "/42", headers: xhr_headers()
    assert_response :not_found
  end
end
