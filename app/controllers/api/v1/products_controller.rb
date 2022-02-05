class Api::V1::ProductsController < Api::V1::ApiController
  include Api::V1::ModelPageable
  include Api::V1::MerchantAuthenticatable
  before_action :authenticate_merchant!

  has_scope :by_label
  has_scope :by_name
  has_scope :by_price, using: %i[min max], type: :hash, allow_blank: true
  has_scope :by_category

  # GET /api/v1/products/:id
  def show
    @product = Product.find(params[:id])
    render_template 'show', product: @product
  end

  # GET /api/v1/products
  def index
    page, per_page = sanitize_page_params(params)
    @products = apply_scopes(Product).published.page(page).per(per_page)
    Rails.logger.info current_scopes
    add_pagination_data(@products, page, per_page)
    render_template 'index', products: @products
  end

  # POST /api/v1/products
  def create
    @product = Product.new(product_params)   
    @product.save!
    render_template 'show', { product: @product }, status: :created
  end

  # PUT /api/v1/products/:id
  def update
    @product = Product.find(params[:id])
    @product.update(product_params)
    
    render_template 'response', { message: 'Product was updated.', product: @product }, status: :ok
  end

  # DELETE /api/v1/trucks/:id
  def destroy
    @product = Product.find(params[:id])
    @product.archive!
    render json: { message: 'Product has been permanently archived' }, status: :ok
  end

  protected

  def product_params
    params.permit(:name, :price, :category_id, labels: [])
  end
end
