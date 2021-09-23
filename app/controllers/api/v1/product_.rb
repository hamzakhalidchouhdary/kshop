module API
  module V1
    class Product_ < Grape::API
      before {authenticate_store_manager}
      before {organization_active?}
      before {find_business}

      resource :product do

        desc 'get all products'
        params do
        end
        get '', root: :product do
          begin
            return {products: @user_business.products, status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'get a products'
        params do
        end
        get ':product_id', root: :product do
          begin
            return { product: find_product, status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'get a order for a product'
        params do
        end
        get ':product_id/order', root: :product do
          begin
            product = find_product
            t = Time.at(product.created_at)
            orders = product.orders
            sold_items = product.order_items
            sold_stock = sold_items.map(&:quantity).inject(0, &:+)
            earning = sold_items.map(&:price).inject(0, &:+)
            return { 
              order: orders.count, 
              sold_stock: sold_stock, 
              invested_amount: sold_stock * product.cost_price,
              except_earning: sold_stock * product.sell_price,
              actual_earning: earning, 
              time: t.strftime("%d of %B, %Y"),
              status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'create product'
        params do
          requires :name, type: String, regexp: /\A[\w+ -:|,]+\Z/
          requires :stock_available, type: Integer, regexp: /\A[0-9]+\Z/
          requires :out_of_stock_limit, type: Integer, regexp: /\A[0-9]+\Z/
          requires :cost_price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          requires :sell_price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
        end
        post '', root: :product do
          begin
            allowed_params = declared(params, include_missing: false)
            product = @user_business.products.new(allowed_params)
            return {product: product, message: 'Product created', status: 200} if product.save
            return {message: 'can not create product', status: 300}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'update product'
        params do
          optional :name, type: String, regexp: /\A[\w+ -:,|]+\Z/
          optional :stock_available, type: Integer, regexp: /\A[0-9]+\Z/
          optional :out_of_stock_limit, type: Integer, regexp: /\A[0-9]+\Z/
          optional :cost_price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          optional :sell_price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
        end
        put ':product_id', root: :product do
          begin
            allowed_params = declared(params, include_missing: false)
            product = find_product
            return {product: product, message: 'Product updated', status: 200} if product.update(allowed_params)
            return {message: 'can not update product', status: 300}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'delete product'
        params do
        end
        delete ':product_id' do
          begin
            product = find_product
            return {message: 'product deleted', status: 200} if product.delete
            return {message: 'can not delete product', status: 500}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc 'delete all products'
        params do
        end
        delete '' do
          begin
            return {message: 'products deleted', status: 200} if @user_business.products.delete_all
            return {message: 'can not delete products', status: 500}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

      end
    end
  end
end