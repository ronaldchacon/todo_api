class Paginator
  def initialize(scope, query_params)
    @scope = scope
    @query_params = query_params
    @page = validate_param!('number', 1)
    @per = validate_param!('size', 10)
  end

  def paginate
    @scope.page(@page).per(@per)
  end

  private

  def validate_param!(name, default)
    return default unless @query_params.dig('page', name)
    unless @query_params['page'][name] =~ /\A\d+\z/
      raise QueryBuilderError.new("page[#{name}]=#{@query_params['page'][name]}"),
      'Invalid Pagination params. Only numbers are supported for "page" and "size".'
    end
    @query_params['page'][name]
  end
end
