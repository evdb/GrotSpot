package GrotSpot::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub auto : Private {
    my ( $self, $c ) = @_;
    my $grotspot = $c->stash->{grotspot} ||= {};

    # push the version onto the stash
    $grotspot->{version} = $GrotSpot::VERSION;

    # show analytics if on live site
    $grotspot->{show_analytics} =
      $c->req->uri->host eq 'www.grotspot.com' ? 1 : 0;

    return 1;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect( $c->uri_for('/in/london') );
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {
}

1;
