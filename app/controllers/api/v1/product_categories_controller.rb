class Api::V1::ProductCategoriesController < Api::V1::ApiController
  include Api::V1::ModelPageable
  include Api::V1::MerchantAuthenticatable
  before_action :authenticate_merchant!

  has_scope :by_name

  # GET /api/v1/categories/:id
  def show
    @category = ProductCategory.find(params[:id])
    render_template 'show', category: @category
  end

  # GET /api/v1/categories
  def index
    @categories = apply_scopes(ProductCategory).published
    render_template 'index', categories: @categories
  end

  # POST /api/v1/categories
  def create
    @category = ProductCategory.new(category_params)   
    @category.save!
    render_template 'show', { category: @category }, status: :created
  end

  # PUT /api/v1/categories/:id
  def update
    @category = ProductCategory.find(params[:id])
    @category.update(category_params)
    
    render_template 'response', { message: 'Category was updated.', category: @category }, status: :ok
  end

  # DELETE /api/v1/trucks/:id
  def destroy
    @category = ProductCategory.find(params[:id])
    @category.archive!
    render json: { message: 'Category has been permanently archived' }, status: :ok
  end


  protected

  def category_params
    params.permit(:name)
  end
end
