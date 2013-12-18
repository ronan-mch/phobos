/**
 * Created by romc on 18-12-13.
 */
$(document).ready(function(){
    /**
     * Intercept feedback email to prevent page change
     * replace form content with feedback response on success
     */
    $('#js_feedback').submit(function(){
       feedback = $(this);
       feedback.parents('.modal-body').load(feedback.attr('action'), feedback.serializeArray());
       return false;
   })
});