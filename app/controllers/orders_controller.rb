class OrdersController < ApplicationController
  before_action :load_order, except: %i(index new create)

  def index
    @orders = Order.page(params[:page]).per Settings.pagenate_orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    if @order.save
      flash[:success] = t "order_create_suc"
      redirect_to orders_path
    else
      flash[:danger] = t "order_create_fail"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @order.update order_params
      update_order_table if params[:order][:table_ids]
      flash[:success] = t "order_update_suc"
      redirect_to orders_path
    else
      flash[:danger] = t "order_update_fail"
      render :edit
    end
  end

  def order_status_change
    @order.update status: params[:do_what].to_i
    respond_to :js
    update_order_status if @order.cancel? || @order.paid?
  end

  private
  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order_not_found"
    redirect_to orders_path
  end

  def update_order_table
    t_ids = params[:order][:table_ids]
    return if t_ids.empty?

    t_ids.each do |t_id|
      table = Table.find_by(id: t_id)
      next if table.nil?

      table.update status: 1
    end
  end

  def update_order_status
    @order.tables.each{|order| order.update(status: 0)}
    OrderTable.where(order_id: @order.id).destroy_all
    OrderDetail.where(order_id: @order.id).destroy_all if @order.cancel?
  end
end
