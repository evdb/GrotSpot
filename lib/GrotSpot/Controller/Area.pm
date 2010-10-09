package GrotSpot::Controller::Area;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub base : PathPart('area') Chained('/') CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index : PathPart('') Chained('base') Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect( $c->uri_for('/area/london') );
}

sub load_area : PathPart('') Chained('base') CaptureArgs(1) {
    my ( $self, $c, $area_code ) = @_;

    # clean up the code
    $area_code =~ s{\W+}{}g;

    # check that the area code exists in the db
    my $area = $c->model('DB::Area')->find( { code => $area_code } )
      || $c->detach('/page_not_found');

    $c->stash->{area} = $area;
}

sub rate : PathPart('') Chained('load_area') Args(0) {
    my ( $self, $c ) = @_;
    my $area = $c->stash->{area};

    # get the point that we should rate
    my ( $lat, $lng ) = $area->get_random_lat_lng();
    $c->stash->{point} = { lat => $lat, lng => $lng };

    # get an ad
    $c->forward('/advert/display');
}

1;
