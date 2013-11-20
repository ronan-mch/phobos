$(document).ready(function() {
    // check for cookie - if not found show the notice
    // when the notice is found, save cookie to prevent re-showing
    if (readCookie('seen_notice') != 'true') {
        $('#js_system_change_notice').removeClass('hidden');
        $('#js_system_change_notice_close').click(function() {
            createCookie('seen_notice', 'true', 364);
        });
    }

    //when the user clicks on the link - present a pop-up
    //$('#js_classic_link').click(choose_classic_dialog)

});

function choose_classic_dialog() {

}

function createCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name,"",-1);
}
