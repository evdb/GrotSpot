var GrotSpot = {

    panorama_point   : null,
    panorama         : null,

    panorama_may_pan       : null,
    panorama_pan_increment : 0.5,
    panorama_pan_interval  : 50,

    panorama_search_radius_initial  : 50,
    panorama_search_radius_multiple : 4,
    panorama_search_radius_max      : 4000,

    initialize_area_map_page: function ( sw_lat, sw_lng, ne_lat, ne_lng ) {

        var sw_corner = new google.maps.LatLng( sw_lat, sw_lng );
        var ne_corner = new google.maps.LatLng( ne_lat, ne_lng );
        var bounds    = new google.maps.LatLngBounds( sw_corner, ne_corner );

        var area_map = new google.maps.Map(
            document.getElementById("area_big_map"),
            {
              center:           bounds.getCenter(),
              zoom:             10,
              mapTypeId:        google.maps.MapTypeId.ROADMAP
            }
        );

        area_map.fitBounds( bounds );
        
        this.load_ratings_onto_map( area_map );
    },

    initialize_area_rating_page: function ( lat, lng ) {

        var point = new google.maps.LatLng( lat, lng );

        // query the streetview service to find the nearest actual point
        var sv     = new google.maps.StreetViewService();
        var radius = this.panorama_search_radius_initial;
        var me     = this;

        var search_function = function () {
            sv.getPanoramaByLocation(
                point,
                radius,
                function( data, status ) {

                    if (status == google.maps.StreetViewStatus.OK) {                    
                        me.panorama_point       = data.location.latLng;
                        me.panorama_description = data.location.description;
                        me.init_panorama();
                        me.activate_rating_buttons();

                    }
                    
                    // need to increase the search radius
                    else if (status == google.maps.StreetViewStatus.ZERO_RESULTS) {
                        
                        radius = radius * me.panorama_search_radius_multiple;
                        
                        if ( radius < me.panorama_search_radius_max ) {
                            search_function();
                        } else {
                            alert('Could not find any streets for you to rate.');
                        }
                        
                    } 
                    
                    // some error that we can't auto fix
                    else {
                        alert( "Something went wrong - please reload the page.");
                    }
                 }
            );            
        };
        
        search_function();


    },    

    init_panorama: function () {
        this.panorama = new  google.maps.StreetViewPanorama(
            document.getElementById("street_view"),
            {
                position: this.panorama_point,
                pov: {
                    heading: 0,
                    pitch:   0,
                    zoom:    0
                },
                navigationControl: false,
                addressControl:    false,
                linksControl:      false
            }
        );
        
        var me = this;
        $('#street_view').mousedown( function () {
            me.stop_panorama_panning();
        });

        this.start_panorama_panning();
    },
    
    start_panorama_panning: function () {
        var panorama = this.panorama;
        
        this.panorama_may_pan = 1;
        var me = this;
        
        var initial_heading   = panorama.getPov().heading;
        var current_heading   = initial_heading;
        var heading_increment = this.panorama_pan_increment;
        
        var pan_scene = function () {
            current_heading = current_heading + heading_increment;
            panorama.setPov({
                heading: current_heading,
                pitch:   0,
                zoom:    0
            });            

            if ( me.panorama_may_pan && current_heading - 360 < initial_heading ) {
                setTimeout( pan_scene, 50 );
            }
        }

        setTimeout( pan_scene, me.panorama_pan_interval );
    },

    stop_panorama_panning : function () {
        this.panorama_may_pan = 0;
    },

    activate_rating_buttons: function () {

        var me  = this;
        var lat = this.panorama_point.lat();
        var lng = this.panorama_point.lng();

        $('#rating_buttons button').each(
            function() {
                var button = $(this);
                var score = button.text();
                
                button.click(
                    function () {

                        $('#rating_comment').html( "Saving your rating..." );
                        me.disable_rating_buttons();

                        $.ajax({
                          type: 'POST',
                          url: '/ajax/store_rating',
                          data: {
                              score: score,
                              lat: lat,
                              lng: lng
                          },
                          success: function ( data ) {
                              me.rating_stored( data );
                          },
                          dataType: 'json'
                        });

                    }
                );
                
            }
        );
    },

    disable_rating_buttons: function () {
        $('#rating_buttons button').attr({ disabled: 'disabled' });
    },
    
    rating_stored: function ( data ) {
        $('#rating_comment').html( "Your rating has been stored" );

        // create the maps of the location
        this.init_maps();

        // change the buttons to the 'next street' button
        var button
            = $("<button></button>")
            .css({ width: 'auto' })
            .html("Rate another street!")
            .click( function () { document.location = document.location });
        $('#rating_buttons').html( button );

        // display data about the street
        var upper = $('#info_pane .upper');
        upper.find('address').text( this.panorama_description );
        upper.find('.rating').text( data.location.average_score );
        upper.find('.votes').text( data.location.vote_count + ' votes' );

        var lower = $('#info_pane .lower');
        lower.find('.ratings_stored').text( data.user.ratings_stored );
        lower.find('.future_discount').text( data.user.future_discount + '%' );
    },

    init_maps: function () {
    
        var point = this.panorama_point;

        var street_map = new google.maps.Map(
            document.getElementById("street_map"),
            {
              center:           point,
              zoom:             14,
              mapTypeId:        google.maps.MapTypeId.ROADMAP,
              disableDefaultUI: true
            }
        );

        var overview_map = new google.maps.Map(
            document.getElementById("overview_map"),
            {
              center:           point,
              zoom:             10,
              mapTypeId:        google.maps.MapTypeId.ROADMAP,
              disableDefaultUI: true
            }
        );

        var street_map_marker = new google.maps.Marker({
            position: point, 
            map: street_map
        });

        var overview_map_marker = new google.maps.Marker({
            position: point, 
            map: overview_map
        });
    },
    
    load_ratings_onto_map : function ( map ) {

        var grotspot = this;
        var bounds   = map.getBounds();

        // check that the map has bounds
        if ( bounds == undefined ) {
            setTimeout(
                function () {
                    grotspot.load_ratings_onto_map( map );
                },
                100
            );
            return;
        };
        
        // fetch the ratings to put on the map
        $.ajax({
            url : '/ajax/find_locations',
            type: 'POST',
            dataType: 'json',
            data: {
                sw_lat : bounds.getSouthWest().lat(),
                sw_lng : bounds.getSouthWest().lng(),
                ne_lat : bounds.getNorthEast().lat(),
                ne_lng : bounds.getNorthEast().lng()          
            },
            success: function(data, textStatus, xhr) {
                grotspot.place_locations_on_map(
                    map,
                    data.locations
                );
            },
            error: function(xhr, textStatus, errorThrown) {
                alert('failure: ' + textStatus );
            }
        });
        
    },
    
    place_locations_on_map : function ( map, locations ) {
        
        $.each(
            locations,
            function (index, loc) {

                var int_score = Math.round( loc.score );

                var point  = new google.maps.LatLng( loc.lat, loc.lng );    

                var marker = new google.maps.Marker({
                    position: point, 
                    map: map,
                    title: loc.score + ' ('+ loc.ratings +' ratings)',
                    icon:   '/static/icons/markers/dot-' + int_score + '.png',
                    shadow: '/static/icons/markers/dot-shadow.png'
                });
            }
        );
        
        
    },
    
};


$( function () {

    // Find inputs that should be cleared on entry
    $('.autowipe').each(

        function ( index, element ) {

            var input = $(element);
            var alt = input.attr('alt');
            
            input
                .focusin(
                    function () {
                        if ( input.val() == '' || input.val() == alt )
                            input.val('').css({ color: '#000' });
                    }
                )
                .focusout(
                    function () {
                        if ( input.val() == '' || input.val() == alt )
                            input.val( alt ).css({ color: '#666' });
                    }
                );

            input.focusout();

        }
    );

    // bind 'myForm' and provide a simple callback function 
    $('#email_form').ajaxForm(
        function() { 
            $('#info_pane .email_box')
                .html("Your email has been stored - thank you."); 
        }
    ); 

});






