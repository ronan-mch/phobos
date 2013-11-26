$(document).ready(function(){
    $('#js_search_type').children().click(function(){
        /* When someone clicks on our search dropdown
         * update dropdown button with translated text
         * update search_type val with key */
        var name = $(this).attr('id');
        var descr = $(this).children('a').text();
        $('#js_search_type_button').text(descr)
        $('input#umlaut\\.search_type').val(name)
    })
});
