(function($){

    window.disable = {

        formEnter: function() {
            $("#form").on("keypress", function(e){
                if (e.keyCode == 13) {
                    e.preventDefault();
                    return false;
                }
            })
        }

    };

    window.toggle = {

        dateShow: function() {
            $(".date-collapse").on("show.bs.collapse", function() {
                $(".date-collapse.in input.month").attr("pattern", "0*([1-9]|1[0-2])")
                $(".date-collapse.in input.month").attr("pattern", "0*([1-9]|[1-2][0-9]|3[0-1])")
                $(".date-collapse.in input.month").attr("pattern", "0*(19[0-9][0-9]|20[0-1][0-9])")
            })
        },

        dateHide: function() {
            $(".date-collapse").on("hide.bs.collapse", function() {
                $(".date-collapse.in input.month").attr("pattern", "")
                $(".date-collapse.in input.month").attr("pattern", "")
                $(".date-collapse.in input.month").attr("pattern", "")
            })
        }

    }

})(jQuery)

$(document).ready(window.disable.formEnter);

$(document).on('turbolinks:load', window.disable.formEnter)

$(document).ready(window.toggle.dateShow);

$(document).on('turbolinks:load', window.toggle.dateShow)

$(document).ready(window.toggle.dateHide);

$(document).on('turbolinks:load', window.toggle.dateHide)