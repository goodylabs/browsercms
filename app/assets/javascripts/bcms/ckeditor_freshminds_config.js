CKEDITOR.stylesSet.add( 'freshminds_styles', [

    { name: 'Title', element: 'h1', attributes: {'class': 'gc-title'}},
    { name: 'Sub Title', element: 'h2', attributes: {'class': 'gc-sub-title'}},
    { name: 'Section Header', element: 'h2', attributes: {'class': 'gc-section-header'}},
    { name: 'Section Content', element: 'p', attributes: {'class': 'gc-section-content'}},
    { name: 'More Link', element: 'a', attributes: {'class': 'gc-link-more'}},
    { name: 'Bullet List', element: 'li', attributes: {'class': 'gc-list-bulletpoint'}},
]);

CKEDITOR.config.stylesSet = 'freshminds_styles';