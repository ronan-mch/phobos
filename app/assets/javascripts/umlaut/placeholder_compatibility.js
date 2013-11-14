/**
 * Created with JetBrains RubyMine.
 * User: romc
 * Date: 14-11-13
 * Time: 15:12
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function(){

    var placeholders =  $('[placeholder]');
    placeholders.focus(function() {
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

    //on submit of form - clear value to prevent sending to search
    placeholders.parents('form').submit(function() {
        $(this).find('[placeholder]').each(function() {
            var input = $(this);
            if (input.val() == input.attr('placeholder')) {
                input.val('');
            }
        })
    });
});