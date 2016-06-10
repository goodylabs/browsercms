CKEDITOR.stylesSet.add( 'freshminds_styles', [

    { name: 'Title', element: 'h1', attributes: {'class': 'gc-title'}},
    { name: 'Sub Title', element: 'h2', attributes: {'class': 'gc-sub-title'}},
    { name: 'Section Header', element: 'h2', attributes: {'class': 'gc-section-header'}},
    { name: 'Sub Section Header', element: 'h3', attributes: {'class': 'gc-sub-section-header'}},
    { name: 'Section Content', element: 'p', attributes: {'class': 'gc-section-content'}},
    { name: 'More Link', element: 'a', attributes: {'class': 'gc-link-more'}},
    { name: 'Image (left aligned)', element: 'img', attributes: {'class': 'gc-img-left'}},
    { name: 'Image (right aligned)', element: 'img', attributes: {'class': 'gc-img-right'}},
    { name: 'Bullet List', element: 'ul', attributes: {'class': 'gc-list'}},
    { name: 'Bullet List (collapsed)', element: 'ul', attributes: {'class': 'gc-list-collapsed'}},
    { name: 'Quote', element: 'blockquote', attributes: {'class': 'gc-quote'}}


]);

CKEDITOR.config.stylesSet = 'freshminds_styles';
CKEDITOR.config.contentsCss = ['/assets/ckeditor.css', '/assets/custom_ckeditor.css'];
CKEDITOR.config.extraAllowedContent = 'a(*){*}[*]'
