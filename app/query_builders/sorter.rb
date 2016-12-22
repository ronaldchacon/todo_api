class Sorter
  DIRECTIONS = %w(asc desc).freeze

  def initialize(scope, params)
    @scope = scope
    @column = params[:sort]
    @direction = params[:dir]
    @klass = @scope.model
  end

  def sort
    return @scope unless @column && @direction
    error!('sort', @column) unless @klass.sort_attributes.include?(@column)
    error!('dir', @direction) unless DIRECTIONS.include?(@direction)
    @scope.order("#{@column} #{@direction}")
  end

  private

  def error!(name, value)
    columns = @klass.sort_attributes.join(', ')
    raise QueryBuilderError.new("#{name}=#{value}"),
    "Invalid sorting params. sort: (#{columns}), 'dir': asc,desc"
  end
end
