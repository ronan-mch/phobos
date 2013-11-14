/**
 * Created with JetBrains RubyMine.
 * User: romc
 * Date: 14-11-13
 * Time: 15:12
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function(){


$('[placeholder]').focus(function() {
    var input = $(this);
    if (input.val() == input.attr('placeholder')) {
        input.val('');
        input.removeClass('placeholder');
    }
}).blur(function() {
        var input = $(this);
        if (input.val() == '' || input.val() == input.attr('placeholder')) {
            input.addClass('placeholder');
            input.val(input.attr('placeholder'));
        }
    }).blur();
});