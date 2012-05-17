class DatasetDatatable
  delegate :params, :h, :link_to, :to => :@view

  def initialize(dataset, view)
    @dataset = dataset
    @view = view
  end

  def as_json(options = {})
    {
      :sEcho => params[:sEcho].to_i,
      :iTotalRecords => @dataset.data_rows_count,
      :iTotalDisplayRecords => results[:total_results],
      :aaData => data
    }
  end

  private

  def data
    results[:rows].map do |row|
      row.map do |value|
        h value
      end
    end
  end

  def results
    @results ||= fetch_results
  end

  def fetch_results
    @dataset.data_search(query,
      :sort => sort_column,
      :sort_direction => sort_direction,
      :page => page,
      :per_page => per_page
    )
  end

  def query
    query_string = @dataset.column_names.map.with_index do |name, i|
      if (value = params["sSearch_#{i}"]).present?
        "#{quote_term(name)}:#{quote_term(value)}"
      end
    end.compact.join(' ')
    query_string << " " << params[:sSearch] if params[:sSearch].present?
    query_string
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    @dataset.column_names[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def quote_term(value)
    if value =~ /["'\s]/
      "\"#{value.gsub('"', '""')}\""
    else
      value
    end
  end
end
