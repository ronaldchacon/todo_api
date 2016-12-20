class Paginator
  def initialize(scope, query_params)
    @scope = scope
    @query_params = query_params
    @page = @query_params.dig('page', 'number') || 1
    @per = @query_params.dig('page', 'size') || 10
  end

  def paginate
    @scope.page(@page).per(@per)
  end
end
