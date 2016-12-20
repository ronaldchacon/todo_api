class ApplicationController < ActionController::API
  protected

  def paginate(scope)
    paginator = Paginator.new(scope, request.query_parameters)
    paginator.paginate
  end
end
