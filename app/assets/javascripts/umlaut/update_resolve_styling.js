/**
 * Created with JetBrains RubyMine.
 * User: romc
 * Date: 14-11-13
 * Time: 09:47
 * To change this template use File | Settings | File Templates.
 */
/**
 * If there is a cover image - decrease container size
 */
$(document).ready(function() {
    if ($('.cover_image').length > 0) {
        $('#js_main_container').removeClass('col-sm-8').addClass('col-sm-6');
    }
});

