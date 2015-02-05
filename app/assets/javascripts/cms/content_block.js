jQuery(document).ready(function(){
  jQuery('.sorted_table').sortable({
    containerSelector: 'table',
    itemPath: '> tbody',
    itemSelector: 'tr',
    axis: 'y',
    update: function() {
      jQuery.post(jQuery(this).data('sort-url'), jQuery(this).sortable('serialize'))
    }
  });
});
