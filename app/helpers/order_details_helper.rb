module OrderDetailsHelper
  def load_product_select o_id
    p_id = OrderDetail.where(order_id: o_id).pluck :product_id
    Product.where.not(id: p_id).map do |t|
      ["#{t.name} | #{I18n.t 'price'} - #{t.price}
        | #{I18n.t 'stock'} - #{t.stock}", t.id]
    end
  end

  def check_order_paid id
    !Order.find_by(id: id).paid?
  end
end
