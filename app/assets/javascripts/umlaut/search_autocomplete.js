jQuery(document).ready(function($) {

    //typeahead for our search bar
    $('input.title_search').typeahead({
        name: 'journals',
        valueKey: 'title',
        limit: 10,
        remote: {
            url: getRemoteUrl(),
            replace: updateUrl
        }
    });

    //get the remot url for our typeahead based on the form's controller
    //with updated action and all form parameters smooshed on
    function getRemoteUrl() {
        var form = $('#OpenURL');
        var url = form.attr("action").replace("journal_search", "auto_complete_for_journal_title");
        return url + "&" + form.serialize() + "&rft.jtitle=";
    }

    //stick the current value onto the autocomplete action url
    function updateUrl(url) {
        searchVal = $('input.title_search').val();
        if (searchVal) {
            //if there's only one word, do a begins with search
            if (searchVal.split(" ").length == 1) {
                url = url.replace(/umlaut\.search_type=.+&/, 'umlaut.title_search_type=begins&');
            }
            return url + searchVal;
        }
        return "";
    }

});

