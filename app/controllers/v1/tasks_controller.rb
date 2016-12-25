module V1
  class TasksController < ApplicationController
    def index
      @list = List.find_by!(id: params[:list_id])
      @tasks = orchestrate_query(@list.tasks)
      render json: @tasks, include: ["list"], status: 200
    end

    def show
      @list = List.find_by!(id: params[:list_id])
      @task = @list.tasks.find_by!(id: params[:id])
      render json: @task, include: ["list"], status: 200
    end

    def create
      @list = List.find_by!(id: params[:list_id])
      attributes = task_attributes.merge(list_id: @list.id)
      @task = Task.new(attributes)
      if @task.save
        render json: @task, status: :created,
               location: v1_list_task_url(@list, @task)
      else
        respond_with_errors(@task)
      end
    end

    def update
      @list = List.find_by!(id: params[:list_id])
      @task = @list.tasks.find_by!(id: params[:id])
      if @task.update(task_attributes)
        render json: @task, status: :ok,
               location: v1_list_task_url(@list, @task)
      else
        respond_with_errors(@task)
      end
    end

    def destroy
      @list = List.find_by!(id: params[:list_id])
      @task = @list.tasks.find_by!(id: params[:id]).destroy
      render status: :no_content
    end

    private

    def task_params
      params.require(:data).permit(:type, attributes: [:title, :description])
    end

    def task_attributes
      task_params[:attributes] || {}
    end
  end
end
