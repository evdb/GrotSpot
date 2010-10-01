function initialize_page ( lat, lng ) {

    var point = new google.maps.LatLng( lat, lng );

    // query the streetview service to find the nearest actual point
    var sv = new google.maps.StreetViewService();
    sv.getPanoramaByLocation( point, 10000, set_panorama );

}

function set_panorama (data, status) {

    if (status == google.maps.StreetViewStatus.OK) {

        var point = data.location.latLng;

        // streetViewControl: false,
        // navigationControl: false,
        // mapTypeControl:    false,
        // scaleControl:      false


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

        var panorama = new  google.maps.StreetViewPanorama(
            document.getElementById("street_view"),
            {
                position: point,
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
        // 
        // google.maps.event.addListener(
        //     panorama,
        //     'pov_changed',
        //     function() {
        // 
        //         var new_heading = panorama.getPov().heading;
        // 
        //         if ( abs( last_heading - new_heading ) > heading_increment ) {
        //             clearInterval(interval_id);
        //         }
        // 
        //     }
        // );
    }
}
