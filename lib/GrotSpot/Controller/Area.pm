package GrotSpot::Controller::Area;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect( $c->uri_for('/in/london') );
}

sub rate : Path : Args(1) {
    my ( $self, $c, $area_code ) = @_;

    # check that the area code exists in the db
    my $area = $c->model('DB::Area')->find( { code => $area_code } )
      || die;

    $c->stash->{area} = $area;

    # get the point that we should rate
    my ( $lat, $lng ) = $area->get_random_lat_lng();
    $c->stash->{point} = { lat => $lat, lng => $lng };

    # get an ad
    $c->forward('/advert/display');
}

1;
