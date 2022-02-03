module Api::V1::ModelPageable
  extend ActiveSupport::Concern
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100
  
  protected 

  def sanitize_page_params(params)
    page = params[:page].to_i.abs
    per_page = params[:per_page].to_i.abs

    page = 1 if (page == 0 || per_page == nil)
    per_page = DEFAULT_PER_PAGE if (per_page == 0 || per_page == nil)
    per_page = MAX_PER_PAGE if (per_page > MAX_PER_PAGE)

    [page, per_page]
  end

  def add_pagination_data(collection, page, per_page)
    @pagination = {
      page: page.to_i,
      per_page: per_page.to_i,
      total_pages: collection.total_pages.to_i,
      total_count: collection.total_count.to_i
    }     
    @pagination[:next_page] = (@pagination[:page] + 1) if @pagination[:total_pages] && @pagination[:total_pages] > @pagination[:page]
    @pagination[:previous_page] = (@pagination[:page] - 1) if @pagination[:page] > 1 && @pagination[:page] <= @pagination[:total_pages]
    @pagination[:page] = 1 if (@pagination[:total_pages] == 1)
  end
end