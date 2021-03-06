jQuery(document).ready(function(){
  jQuery('.sorted_table').sortable({
    containerSelector: 'table',
    itemPath: '> tbody',
    itemSelector: 'tr',
    opacity: 0.75,
    axis: 'y',
    scroll: false,
    update: function() {
      jQuery.post(jQuery(this).data('sort-url'), jQuery(this).sortable('serialize'))
    }
  });
});
