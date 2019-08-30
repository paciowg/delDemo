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
            $(".date-collapse.show input.month").attr("pattern", "0*([1-9]|1[0-2])")
            $(".date-collapse.show input.day").attr("pattern", "0*([1-9]|[1-2][0-9]|3[0-1])")
            $(".date-collapse.show input.year").attr("pattern", "0*(19[0-9][0-9]|20[0-1][0-9]|2020)")
            $(".date-collapse.show input.month").attr("required", true)
            $(".date-collapse.show input.day").attr("required", true)
            $(".date-collapse.show input.year").attr("required", true)
        },

        dateHide: function() {
            $(".date-collapse:not(.show) input.month").attr("pattern", ".{0}")
            $(".date-collapse:not(.show) input.day").attr("pattern", ".{0}")
            $(".date-collapse:not(.show) input.year").attr("pattern", ".{0}")
            $(".date-collapse:not(.show) input.month").attr("required", false)
            $(".date-collapse:not(.show) input.day").attr("required", false)
            $(".date-collapse:not(.show) input.year").attr("required", false)
            $(".date-collapse:not(.show) input.month").val("")
            $(".date-collapse:not(.show) input.day").val("")
            $(".date-collapse:not(.show) input.year").val("")
        },

        dateShowListener: function() {
            window.toggle.dateShow
            $(".date-collapse").on("shown.bs.collapse", window.toggle.dateShow)
        },

        dateHideListener: function() {
            window.toggle.dateHide()
            $(".date-collapse").on("hidden.bs.collapse", window.toggle.dateHide)
        },

        modalLinkListener: function() {
            $("a.about").click(function(){
                $(".modal-footer > a").attr("href", "/about")
            });
            $(".banner-content").click(function(){
                $(".modal-footer > a").attr("href", "/")
            });
        }

    }

})(jQuery)

$(document).ready(window.disable.formEnter);
$(document).on('turbolinks:load', window.disable.formEnter);

$(document).ready(window.toggle.dateShowListener);
$(document).on('turbolinks:load', window.toggle.dateShowListener);

$(document).ready(window.toggle.dateHideListener);
$(document).on('turbolinks:load', window.toggle.dateHideListener);

$(document).ready(window.toggle.modalLinkListener);
$(document).on('turbolinks:load', window.toggle.modalLinkListener);