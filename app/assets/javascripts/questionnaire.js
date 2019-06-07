(function($){

    window.disable = {

        formEnter: function() {
            $("#form").on("keypress", function(e){
                console.log("key " + e.keyCode + " was pressed in a form");
                if (e.keyCode == 13) {
                    e.preventDefault();
                    return false;
                }
            })
        }

    }

})(jQuery)

$(document).ready(window.disable.formEnter);

$(document).on('turbolinks:load', window.disable.formEnter)