var GrotSpot = {

    panorama_point: null,

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
                    me.panorama_point = data.location.latLng;
                    me.init_panorama();
                    me.activate_rating_buttons();
                    me.init_maps();
                } else {
                    alert( "Something went wrong - please reload the page.");
                }
             }
        );

    },    

    init_panorama: function () {
        var panorama = new  google.maps.StreetViewPanorama(
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

        // var last_heading = panorama.getPov().heading;
        // var heading_increment = 0.5;
        // 
        // var interval_id = setInterval(
        //     function () {
        //         last_heading = last_heading + heading_increment;
        //         panorama.setPov({
        //             heading: last_heading,
        //             pitch:   0,
        //             zoom:    0
        //         });
        //     },
        //     50
        // );

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

        var button
            = $("<button></button>")
            .css({ width: 'auto' })
            .html("Rate another street!")
            .click( function () { document.location = document.location });

        $('#rating_buttons').html( button );
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






