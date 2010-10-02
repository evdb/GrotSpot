package GrotSpot::Controller::Ajax;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub store_rating : Local {
    my ( $self, $c ) = @_;

    my $req   = $c->req;
    my $score = $req->param('score');
    my $lat   = $req->param('lat');
    my $lng   = $req->param('lng');

    # get the location
    my $location =
      $c->model('DB::Location')->find_or_create( { lat => $lat, lng => $lng } )
      || die "Could not create location";

    # Check that the session has been set up
    $c->session->{ratings_stored}++;    # fix the session
    $c->session->{future_discount} =
      $c->future_discount( $c->session->{ratings_stored} );
    my $session_id = $c->sessionid;

    # save the rating
    my $rating = $location->add_to_ratings(
        {
            score      => $score,
            session_id => $session_id
        }
    ) || die "Could not save rating";

    $c->stash->{json_data} = {
        score    => $score,    #
        location => {
            average_score => $location->average_score,
            vote_count    => $location->ratings->count
        },
        user => {
            ratings_stored  => $c->session->{ratings_stored},
            future_discount => $c->session->{future_discount},
            email           => $c->session->{email} || '',
            session_id      => $session_id,
        }
    };
}

sub end : Private {
    my ( $self, $c ) = @_;
    $c->detach('View::JSON');
}

1;
