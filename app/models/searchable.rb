module Searchable

  attr_accessor :search_per_page, :search_attributes, :search_joins

  def search(params)
    query = params[:q] || ''
    page = (params[:page] || 0).to_i
    offset = page * search_per_page
    relation = order("#{table_name}.updated_at DESC").limit(search_per_page).offset(offset).joins(*search_joins)
    terms = query.split(/\s+/)
    terms.each do |term|
      quoted_term = connection.quote "%#{term}%"
      condition_string = search_attributes.map do |attribute|
        "#{attribute} LIKE #{quoted_term}"
      end.join(' OR ')
      relation = relation.where(condition_string)
    end
    relation
  end

end