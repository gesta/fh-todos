$(document).ready(function() {
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

  function sortTable(table, dataCell, sortClass, sortOrder) {
    var rows = $('tbody > tr', table);
    rows.sort(function (rowA, rowB) {
      var keyA = $(rowA).children('.' + dataCell).children('.' + sortClass).text()
      var keyB = $(rowB).children('.' + dataCell).children('.' + sortClass).text()
      if (sortOrder.toLowerCase() === 'asc') {
        return (keyA > keyB) ? true : false;
      } else if (sortOrder.toLowerCase() === 'desc') {
        return (keyA < keyB) ? true : false;
      }
    });
    $.each(rows, function(index, row) { table.append(row); });
  }

  function alternatingSort(target) {
    if(sortColumn.val() === 'desc') { sortColumn.val('asc'); }
    else if(sortColumn.val() === 'asc') { sortColumn.val('desc'); }
    else { sortColumn.val('desc'); }

  }

  $('#due-date-column').click(function(event) {
    sortColumn = $(event.target);
    alternatingSort(sortColumn);
    sortTable($('table'), 'date-time-td', 'date-to-sort', sortColumn.val());
  });

  $('#priority-column').click(function(event) {
    sortColumn = $(event.target)
    alternatingSort(sortColumn);
    sortTable($('table'), 'priority-td', 'priority-to-sort', sortColumn.val())
  });
});
