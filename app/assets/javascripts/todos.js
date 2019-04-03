$(document).ready(function() {
  $('#todos-table').DataTable({
    'searching': false,
    'lengthChange': false,
    'columns': [
      {'orderable': false},
      {'orderable': false},
      null,
      null,
      {'orderable': false }
    ]
  });

  $('.custom-control-input').click(function(event) {
    var csrfToken = $('meta[name=csrf-token]')[0].content;
    var checkbox = $(event.target);
    var todoId = checkbox.val();
    var payload = {
      'id': todoId,
      'completed?': checkbox.prop('checked')
    };

    $.ajax({
      'headers': {
        'X-CSRF-Token': csrfToken
      },
      type: 'PATCH',
      url: '/todos/' + todoId,
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify(payload)
    })
      .done(function(success) {
        checkbox.prop('checked') && checkbox.closest('tr').addClass('highlight');
      })
      .fail(function(error) {
        checkbox.prop('checked', !checkbox.prop('checked'));
      })
      .always(function() {
        if(checkbox.prop('checked')) {
          checkbox.closest('tr').addClass('highlight');
        } else {
          checkbox.closest('tr').removeClass('highlight');
        }
      });
  });
});
