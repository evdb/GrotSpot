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

    # save the rating
    $c->session->{ratings_stored}++;    # fix the session
    my $rating = $location->add_to_ratings(
        { score => $score, session_id => $c->sessionid } )
      || die "Could not save rating";

    $c->stash->{json_data} = {
        score         => $score,                    #
        average_score => $location->average_score
    };
}

sub end : Private {
    my ( $self, $c ) = @_;
    $c->detach('View::JSON');
}

1;
