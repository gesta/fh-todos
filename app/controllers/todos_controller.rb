class TodosController < ApplicationController
  def index
    @todos = Todo.all
    respond_to do |format|
      format.html { render :index }
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
      end
    else
      @todo = Todo.new(todo_params)
      respond_to do |format|
        format.html do
          flash[:error] = 'There are errors in the entry!'
          render :new
        end
      end
    end
  end

  def edit
    @todo = Todo.find_by_id(params[:id])
    if @todo
      respond_to do |format|
        format.html { render :edit }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'There is no such entry!'
          redirect_to todos_path
        end
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
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'The entry is not deleted!'
          redirect_to todos_path
        end
      end
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:completed?, :content, :due_date, :priority)
  end
end
