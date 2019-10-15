module OrdersHelper
  def check_order_status order
    return "status-" + order.status if order
  end

  def load_order_table order
    result = []
    order.tables.map do |o_t|
      result << array_table_item(o_t)
    end
    Table.where(status: 0).map do |ta|
      result << array_table_item(ta)
    end
    result
  end

  def array_table_item table
    ["#{I18n.t('number_table')} - #{table.table_number} |
      #{I18n.t('table_size')} - #{table.max_size}", table.id]
  end

  def load_order_preselected order
    order.tables.ids
  end
end
