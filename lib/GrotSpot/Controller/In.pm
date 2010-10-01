package GrotSpot::Controller::In;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect( $c->uri_for('/in/london') );
}

sub in : Path : Args(1) {
    my ( $self, $c, $location_code ) = @_;

    # check that the location code exists in the db
    my $location = $c->model('DB::Location')->find( { code => $location_code } )
      || die;

    $c->stash->{location} = $location;

    # get the point that we should rate
    my ( $lat, $lon ) = $location->get_random_lat_lon();
    $c->stash->{point} = { lat => $lat, lon => $lon };

}

1;
