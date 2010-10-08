package GrotSpot::Controller::Admin::Adverts;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub list : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{adverts} =
      $c->model('DB::Advert')->search( {}, { order_by => 'id' } );
}

1;
