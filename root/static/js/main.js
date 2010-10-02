var GrotSpot = {

    panorama_point   : null,
    panorama         : null,
    panorama_may_pan : null,

    initialize_page: function ( lat, lng ) {
        var point = new google.maps.LatLng( lat, lng );

        // query the streetview service to find the nearest actual point
        var sv = new google.maps.StreetViewService();
        var me = this;

        sv.getPanoramaByLocation(
            point,
            10000,
            function( data, status ) {
                if (status == google.maps.StreetViewStatus.OK) {                    
                    me.panorama_point       = data.location.latLng;
                    me.panorama_description = data.location.description;
                    me.init_panorama();
                    me.activate_rating_buttons();
                } else {
                    alert( "Something went wrong - please reload the page.");
                }
             }
        );

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
        var heading_increment = 0.5;
        
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

        setTimeout( pan_scene, 50 );
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
        $('#info_pane address').text( this.panorama_description );
        $('#info_pane .rating').text( data.location.average_score );
        $('#info_pane .votes').text( data.location.vote_count + ' votes' );

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
    }
    
};






