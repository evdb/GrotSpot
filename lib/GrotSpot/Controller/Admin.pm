package GrotSpot::Controller::Admin;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub auto : Private {
    my ( $self, $c ) = @_;

    # switch off analytics for this section of the site
    my $grotspot = $c->stash->{grotspot};
    $grotspot->{show_analytics} = 0;
    $grotspot->{show_adverts}   = 0;
    $grotspot->{show_feedback}  = 0;
    $grotspot->{show_social_buttons}  = 0;

    # check that the user is allowed in here
    my $expected_secret = 'stinkypops';
    my $actual_secret                     #
      = $c->req->param('admin_secret')    # get off url
      || $c->session->{admin_secret}      # load from session
      || '';                              # none

    if ( $actual_secret ne $expected_secret ) {
        $c->res->body('please provide the admin secret');
        $c->res->status(200);
        return 0;
    }

    # store the secret in the session for the next visit
    $c->session->{admin_secret} = $actual_secret;

    return 1;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
}

1;
