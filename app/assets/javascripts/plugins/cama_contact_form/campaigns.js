jQuery(function() {
  $('form').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.fieldset').hide();
    return event.preventDefault();
  });

  $('.leads_filter').on('change', function(){
    $('#leads_filter_form').submit();
  });

  return $('form').on('click', '.add_fields', function(event) {
    const time = new Date().getTime();
    const regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });
});