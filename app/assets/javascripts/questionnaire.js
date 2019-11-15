(function($){

    window.disable = {

        formEnter: function() {
            $("#form").on("keypress", function(e){
                if (e.keyCode == 13) {
                    e.preventDefault();
                    return false;
                }
            })
        },

        unsupportedCards: function() {
            $('.card').click(function(e) {
                if ($(this).hasClass('disabled-card')){
                    e.preventDefault();
                    return false;
                }
                return true;
            })
        },

        itemSearch: function() {
            $("form.search-form > div.input-group > div.input-group-append > button")
                    .addClass("disabled")
                    .prop("disabled", true)
                    .parents("form").submit();
            $("form.search-form > div.input-group > input.form-control")
                    .prop("disabled", true)
                    .val("")
                    .attr("placeholder", "Searching through assessments, may take a second...");
            $("form.search-form > select.search-dropdown").prop("disabled", true);
        }

    };

    window.toggle = {

        dateShow: function() {
            $(".date-collapse.show input.month")
                    .attr("pattern", "0*([1-9]|1[0-2])")
                    .attr("required", true);
            $(".date-collapse.show input.day")
                    .attr("pattern", "0*([1-9]|[1-2][0-9]|3[0-1])")
                    .attr("required", true);
            $(".date-collapse.show input.year")
                    .attr("pattern", "0*(19[0-9][0-9]|20[0-1][0-9]|2020)")
                    .attr("required", true);
        },

        dateHide: function() {
            $(".date-collapse:not(.show) input.month")
                    .attr("pattern", ".{0}")
                    .attr("required", false)
                    .val("");
            $(".date-collapse:not(.show) input.day")
                    .attr("pattern", ".{0}")
                    .attr("required", false)
                    .val("");
            $(".date-collapse:not(.show) input.year")
                    .attr("pattern", ".{0}")
                    .attr("required", false)
                    .val("");
        },

        dateShowListener: function() {
            $(".date-collapse").on("shown.bs.collapse", window.toggle.dateShow);
        },

        dateHideListener: function() {
            window.toggle.dateHide();
            $(".date-collapse").on("hidden.bs.collapse", window.toggle.dateHide);
        },

        modalLinkListener: function() {
            $("a.about").click(function(){
                $(".modal-footer > a").attr("href", "/about");
            });
            $(".banner-content").click(function(){
                $(".modal-footer > a").attr("href", "/");
            });
        },

        codeChange: function() {
            if ($('div.toggle-width > div.toggle').hasClass("off")) {
                window.toggle.codeToCMS();
            } else {
                window.toggle.codeToLOINC();
            }
        },

        codeToLOINC: function() {
            $('.qop-container-blue')
                    .addClass('qop-container-green')
                    .removeClass('qop-container-blue');
            $('.home-cards-container .card').each(function() {
                newHref = $(this).attr('href').replace("loinc=false", "loinc=true");
                $(this).attr('href', newHref);
            })
            $('.no-loinc').addClass('disabled-card');
        },

        codeToCMS: function() {
            $('.qop-container-green')
                    .addClass('qop-container-blue')
                    .removeClass('qop-container-green');
            $('.home-cards-container .card, ').each(function() {
                newHref = $(this).attr('href').replace("loinc=true", "loinc=false");
                $(this).attr('href', newHref);
            })
            $('.no-loinc').removeClass('disabled-card');
        },

        codeListener: function() {
            $(".toggle-group").click(window.toggle.codeChange);
        }

    };

    window.search = {

        cardSearchListener: function() {
            $("input.card-search").on("keyup", window.search.filterCards);
        },

        filterCards: function() {
            let dirtySearchTerms = $("input.card-search").val().split(/\s+/);
            let searchTerms = dirtySearchTerms.filter(function(el) { return el; });
            if (searchTerms.length == 0) {
                if (!$('.home-browse-cards').hasClass('show')) $('.home-browse-cards').addClass('show');
                if ($('.home-search-cards').hasClass('show')) $('.home-search-cards').removeClass('show');
                if ($('p.search-result-counter').hasClass('show')) $('p.search-result-counter').removeClass('show');
            } else {
                if ($('.home-browse-cards').hasClass('show')) $('.home-browse-cards').removeClass('show');
                if (!$('.home-search-cards').hasClass('show')) $('.home-search-cards').addClass('show');
                if (!$('p.search-result-counter').hasClass('show')) $('p.search-result-counter').addClass('show');
                let count = 0;
                $('.home-search-cards section .card').each(function() {
                    let text = $(this).text();
                    let matches = true;
                    searchTerms.forEach(function(term) {
                        if (matches) matches = text.toUpperCase().includes(term.toUpperCase());
                    });
                    if (matches) {
                        if (!$(this).hasClass('show')) $(this).addClass('show');
                        count++;
                    } else {
                        $(this).removeClass('show');
                    }
                });
                $('p.search-result-counter strong').text(count);
            }
        },

        itemSearchListener: function() {
            $("#item-search-submit").on("click", window.search.switchToSpinner);
        },

        switchToSpinner: function() {
            $(".item-search-text").removeClass("show");
            $(".white-spinner").addClass("show");
            window.disable.itemSearch();
        }
        
    };


    $(document).on('turbolinks:load', window.disable.formEnter);

    $(document).on('turbolinks:load', window.disable.unsupportedCards);

    $(document).on('turbolinks:load', window.toggle.dateShowListener);

    $(document).on('turbolinks:load', window.toggle.dateHideListener);

    $(document).on('turbolinks:load', window.toggle.modalLinkListener);

    $(document).on('turbolinks:load', window.search.cardSearchListener);

    $(document).on('turbolinks:load', window.search.itemSearchListener);

    $(document).on('turbolinks:load', function() { 
        $('input[type="checkbox"].code-toggle').bootstrapToggle(); // assumes .code-toggle for toggle checkboxes
        window.toggle.codeListener();
    });

})(jQuery);