class TodosController < ApplicationController
  before_action :logged_in_as_admin?, only: [:destroy]
  before_action :logged_in_user, except: [:index]

  def index
    @todos = Todo.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @todos }
    end
  end

  def new
    @todo = Todo.new
  end

  def create
    todo = Todo.new(todo_params)
    if todo.save
      respond_to do |format|
        format.html do
          flash[:info] = "You've successfuly created a todo entry."
          redirect_to todos_path
        end
        format.json { render json: {}, status: :ok }
      end
    else
      @todo = Todo.new(todo_params)
      respond_to do |format|
        format.html do
          flash[:error] = 'There are errors in the entry!'
          render :new
        end
        format.json { render json: todo.errors.messages, status: :bad_request }
      end
    end
  end

  def edit
    @todo = Todo.find_by_id(params[:id])
    if @todo
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @todo.to_json }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'There is no such entry!'
          redirect_to todos_path
        end
        format.json { render json: {}, status: :not_found }
      end
    end
  end

  def update
    todo = Todo.find_by_id(params[:id])
    if todo&.update(todo_params)
      respond_to do |format|
        format.html do
          flash[:info] = "You've successfuly updated a todo entry."
          redirect_to todos_path
        end
        format.json { render json: {}, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'There are errors in the entry!'
          @todo = Todo.new(todo_params)
          render :edit
        end
        format.json do
          status = todo.present? ? :bad_request : :not_found
          render json: todo&.errors&.messages.to_h, status: status
        end
      end
    end
  end

  def destroy
    todo = Todo.find_by_id(params[:id])
    if todo&.delete
      respond_to do |format|
        format.html do
          flash[:info] = "You've successfuly deleted a todo entry."
          redirect_to todos_path
        end
        format.json { render json: {}, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'The entry is not deleted!'
          redirect_to todos_path
        end
        format.json { render json: {}, status: :not_found }
      end
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:completed?, :content, :due_date, :priority)
  end
end
