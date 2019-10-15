$('document').ready(function(){
  $('.dropdown-toggle').on('mouseenter', function () {
    if (!$(this).parent().hasClass('show')) {
        $(this).click();
    }
  });

  $('.btn-group, .dropdown').on('mouseleave', function () {
    if ($(this).hasClass('show')){
      $(this).children('.dropdown-toggle').first().click();
    }
  });

  $('#order-table-select').select2({
    placeholder: I18n.t("pick_table_placeholder")
  });

  $('#list-products').select2({
    placeholder: I18n.t("pick_product"),
  });

  $(".table_product").DataTable();
});

window.showModal = function(table_id){
  $.ajax({
    url: '/tables/' + table_id
  });
}

window.update_amount = function(order_id, order_detail_id){
  id_quantily = '#order-detail-quantily-' + order_detail_id;
  id_amount = '#order-detail-amount-' + order_detail_id;
  quantily = $(id_quantily).val();
  console.log('ORDER_ID: ' + order_id + ' ORDER_DETAIL_ID: ' + order_detail_id + ' QUANTILY: ' + quantily);

  $.ajax({
    url: "/orders/" + order_id + "/order_details/" + order_detail_id + "/update_amount",
    data: {
      quantily: quantily
    },
    success: function(result){
      console.log(result.amount);
      console.log(result.total_amount);
      $(id_amount).html(result.amount);
      $('#order-total-amount').html(result.total_amount);
    }
  });
}
