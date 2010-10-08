package GrotSpot::Controller::Admin::Adverts;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use GrotSpot::Form::Advert;

sub list : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{adverts} =
      $c->model('DB::Advert')->search( {}, { order_by => 'id' } );
}

sub edit : Local {
    my ( $self, $c, $advert_id ) = @_;

    my $advert_rs = $c->model('DB::Advert');
    my $advert    #
      = $advert_rs->find($advert_id)
      || $advert_rs->new_result( {} );

    my $form = GrotSpot::Form::Advert->new( item => $advert );
    $c->stash( form => $form );

    # process the form and return if there were errors
    return if !$form->process( params => $c->req->params );

    $c->res->redirect( $c->uri_for('') );
}

1;
