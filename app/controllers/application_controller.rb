class ApplicationController < ActionController::API
  rescue_from QueryBuilderError, with: :query_builder_error

  protected

  def orchestrate_query(scope, actions = :all)
    QueryOrchestrator.new(scope: scope, params: params, request: request,
                          response: response, actions: actions).run
  end

  def query_builder_error(error)
    render status: 400, json: {
      error: {
        message: error.message,
        invalid_params: error.invalid_params
      }
    }
  end
end
