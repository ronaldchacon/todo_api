module V1
  class TasksController < ApplicationController
    before_action :authenticate_user

    def index
      @list = current_user.lists.find_by!(id: params[:list_id])
      @tasks = orchestrate_query(@list.tasks)
      render json: @tasks, include: ["list"], status: 200
    end

    def show
      @task = current_user.tasks.find_by!(id: params[:id])
      render json: @task, include: ["list"], status: 200
    end

    def create
      @list = current_user.lists.find_by!(id: params[:list_id])
      attributes = task_attributes.merge(list_id: @list.id)
      @task = Task.new(attributes)
      if @task.save
        render json: @task, status: :created, location: v1_task_url(@task)
      else
        respond_with_errors(@task)
      end
    end

    def update
      @task = current_user.tasks.find_by!(id: params[:id])
      if @task.update(task_attributes)
        render json: @task, status: :ok, location: v1_task_url(@task)
      else
        respond_with_errors(@task)
      end
    end

    def destroy
      current_user.tasks.find_by!(id: params[:id]).destroy
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
