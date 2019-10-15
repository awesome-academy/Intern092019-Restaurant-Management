class OrderDetailsController < ApplicationController
  before_action :load_order_detail, only: %i(update_amount destroy)

  def index
    @order = Order.find_by(id: params[:order_id])
    if @order.pending? || @order.cancel?
      flash[:danger] = t("access_denied")
      redirect_to orders_path
    end
    @order_detail_product = OrderDetail.new
    return if @order_details = @order.order_details.includes(product: :picture)

    flash[:danger] = t "order_detail_not_found"
    redirect_to orders_path
  end

  def new; end

  def create
    @order_detail = OrderDetail.new order_detail_params
    if @order_detail.save
      total_amount = @order_detail.order.total_amount + @order_detail.amount
      @order_detail.order.update(total_amount: total_amount)
      flash.now[:success] = t "create_order_detail_suc"
      respond_to :js
    else
      flash.now[:danger] = t "create_order_detail_fail"
      render :index
    end
  end

  def destroy
    if @order_detail.destroy
      total_amount = @order_detail.order.total_amount - @order_detail.amount
      @order_detail.order.update(total_amount: total_amount)
      flash[:success] = "Delete product success!"
    else
      flash[:danger] = "Delete product fails! something wrong"
    end
    redirect_to order_order_details_path
  end

  def update_amount
    new_amount = @order_detail.price * params[:quantily].to_i
    new_total_amount = @order_detail.order.total_amount - @order_detail.amount

    @order_detail.update(quantily: params[:quantily].to_i, amount: new_amount)
    new_total_amount += @order_detail.amount
    @order_detail.order.update(total_amount: new_total_amount)
    render json: {amount: new_amount, total_amount: new_total_amount}
  end

  private
  def order_detail_params
    params.require(:order_detail).permit(OrderDetail::ORDER_DETAIL_PARAMS)
          .merge(price: load_product_price, amount: load_product_price)
  end

  def load_product_price
    g_price = Product.find_by(id: params[:order_detail][:product_id]).price
    return g_price if g_price.present?
  end

  def load_order_detail
    @order_detail = OrderDetail.find_by(id: params[:id])
    return if @order_detail

    flash[:danger] = "Can't find order detail"
    redirect_to order_order_details_path
  end
end
