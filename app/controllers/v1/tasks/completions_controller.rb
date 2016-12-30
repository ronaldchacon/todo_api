module V1
  module Tasks
    class CompletionsController < ApplicationController
      before_action :authenticate_user

      def complete
        @task = Task.find_by!(id: params[:task_id])
        if @task.update(task_attributes)
          render json: @task, status: :ok, location: v1_task_url(@task)
        else
          respond_with_errors(@task)
        end
      end

      def uncomplete
        @task = Task.find_by!(id: params[:task_id])
        if @task.update(task_attributes)
          render json: @task, status: :ok, location: v1_task_url(@task)
        else
          respond_with_errors(@task)
        end
      end

      private

      def task_params
        params.require(:data).permit(:type, attributes: [:completed_at])
      end

      def task_attributes
        task_params[:attributes] || {}
      end
    end
  end
end
