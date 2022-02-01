module API
  module V1
    class Order_ < Grape::API
      before {authenticate_account_manager}
      before {organization_active?}
      before {find_business}
      
      resource :order do
        desc "return all orders"
        get '', root: :order do
          begin
            return {orders: @user_business.orders, status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc "return a order"
        get ':order_id', root: :order do
          begin
            order = find_order
            return {order: order, products: order.products, status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc "create a order"
        params do
          requires :total_products, type: Integer, regexp: /\A[0-9]+\Z/
          requires :total_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          requires :discount_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          requires :paid_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          requires :customer_name, type: String, regexp: /\A[\w+ ]+\Z/
          requires :delivery_address, type: String, regexp: /\A[\w#-\.,\/ ]+\Z/
          requires :billing_address, type: String, regexp: /\A[\w#-\.,\/ ]+\Z/
          requires :contact_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          requires :products, type: Array, allow_blank: { value: false, message: 'not selected' } do
            requires :product_id, type: Integer, regexp: /\A[0-9]+\Z/
            requires :quantity, type: Integer, regexp: /\A[0-9]+\Z/
            requires :price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          end
        end
        post '', root: :order do
          begin
            allowed_params = declared(params, include_missing: false)
            products = allowed_params[:products]
            order = nil
            order_items = nil
            Order.transaction do
              order = @user_business.orders.new(allowed_params.except(:products))
              order.save
              products.each {|h| h[:created_at] = order.created_at}
              products.each {|h| h[:updated_at] = order.updated_at}
              order_items = order.order_items.insert_all(products)
            end
            return {order: order, order_items: order.products, status: 200}
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end

        desc "update a order"
        params do
          optional :total_products, type: Integer, regexp: /\A[0-9]+\Z/
          optional :total_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          optional :discount_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          optional :paid_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          optional :customer_name, type: String, regexp: /\A[\w+ ]+\Z/
          optional :delivery_address, type: String, regexp: /\A[\w#-\.,\/ ]+\Z/
          optional :billing_address, type: String, regexp: /\A[\w#-\.,\/ ]+\Z/
          optional :contact_no, type: String, regexp: /\A(\+).[0-9]+\Z/
          optional :products, type: Array do
            requires :product_id, type: Integer, regexp: /\A[0-9]+\Z/
            requires :quantity, type: Integer, regexp: /\A[0-9]+\Z/
            requires :price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
          end
        end
        put ':order_id', root: :order do
          begin
            allowed_params = declared(params, include_missing: false)
            products = allowed_params[:products]
            order = find_order
            unless (order.paid_amount.to_i != 0)
              order_items = nil
              Order.transaction do
                order.update(allowed_params.except(:products))
                if products
                  products.each {|h| h[:created_at] = order.created_at}
                  products.each {|h| h[:updated_at] = order.updated_at}
                  order_items = order.order_items.insert_all(products)
                end
              end
              return {order: order, order_items: order.products, status: 200}
            else
              return {message: "can not update confirmed order", status: 300}
            end
          rescue Exception => e
            error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
          end
        end
        resource ':order_id/return' do
          desc "get returns of an order"
          params do
          end
          get '', root: :order do
            begin
              order = find_order
              return {return: order.returns, status: 200}
            rescue Exception => e
              error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
            end
          end

          desc "get return of an order"
          params do
          end
          get ':return_id', root: :order do
            begin
              order_return = find_return
              return {return: order_return, products: order_return.products, status: 200}
            rescue Exception => e
              error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
            end
          end

          desc 'create return of an order'
          params do
            requires :total_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
            requires :paid_amount, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
            requires :products, type: Array, allow_blank: { value: false, message: 'not selected' } do
              requires :product_id, type: Integer, regexp: /\A[0-9]+\Z/
              requires :quantity, type: Integer, regexp: /\A[0-9]+\Z/
              requires :price, type: Float, regexp: /\A[0-9]+\.[0-9]+\Z/
            end
          end
          post '', root: :order do
            begin
              allowed_params = declared(params, include_missing: false)
              products = allowed_params[:products]
              order_return = nil
              returned_items = nil
              Return.transaction do
                order = find_order
                order_return = order.returns.new(allowed_params.except(:products))
                order_return.save
                products.each {|h| h[:created_at] = order_return.created_at}
                products.each {|h| h[:updated_at] = order_return.updated_at}
                returned_items = order_return.returned_items.insert_all(products)
              end
              return {return: order_return, returned_items: order_return.products, status: 200}
            rescue Exception => e
              error!({error: e.message, status: 400, message: 'Something went wrong, Try later'})
            end
          end
        end
      end
    end
  end
end