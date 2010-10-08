package GrotSpot::Controller::Advert;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub display : Local {
    my ( $self, $c ) = @_;

    # pick a random advert
    my $adverts_rs = $c->model('DB::Advert')->enabled;

    my $advert =
      $adverts_rs->search( {}, { order_by => 'random()', rows => 1, } )->first;

    $advert->record_view;

    # put it on the stash to display
    $c->stash->{advert} = $advert;
}

1;
