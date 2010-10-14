package GrotSpot::Controller::Ajax;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use Email::Valid;

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

    # get the email if we have one
    my $email_id = $c->session->{email_id} || undef;

    # save the rating
    my $rating = $location->add_to_ratings(
        {
            score      => $score,
            session_id => $session_id,
            email_id   => $email_id,
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

sub store_email : Local {
    my ( $self, $c ) = @_;

    my $req       = $c->req;
    my $raw_email = $req->param('email');

    # check that the email is valid
    my $valid_email = Email::Valid->address( lc $raw_email );
    if ( !$valid_email ) {
        $c->response->body("Bad email address");
        $c->response->status(404);
        $c->detach;
    }

    # find the email in db
    my $email =
      $c->model('DB::Email')->find_or_create( { email => $valid_email } )
      || die "could not create entry for $valid_email";

    # set the email into the session
    $c->session->{email}    = $valid_email;
    $c->session->{email_id} = $email->id;

    # find all ratings done in this session with no email and fix them.
    $c->model('DB::Rating')
      ->search( { session_id => $c->sessionid, email_id => undef } )
      ->update( { email_id => $email->id } );

    $c->stash->{json_data} = { email_saved => 1, };
}

sub find_locations : Local {
    my ( $self, $c ) = @_;
    my $req = $c->req;

    my $args = {};
    foreach my $key (qw( sw_lat sw_lng ne_lat ne_lng )) {
        my $val = $req->param($key);
        die "need $key" unless defined $val;
        $args->{$key} = $val;
    }

    # FIXME - deal with dateline
    my $locations = $c->model('DB::Location')->search(
        {    #
            lat => {
                '>=' => $args->{sw_lat},    #
                '<=' => $args->{ne_lat}
            },
            lng => {
                '>=' => $args->{sw_lng},    #
                '<=' => $args->{ne_lng}
            },
        },
        { rows => 300, }
    );

    my @results = ();
    while ( my $loc = $locations->next ) {
        push @results,
          {
            lat     => $loc->lat,
            lng     => $loc->lng,
            score   => $loc->average_score,
            ratings => $loc->ratings->count,
          };
    }

    $c->stash->{json_data} = { locations => \@results };

}

sub end : Private {
    my ( $self, $c ) = @_;
    $c->detach('View::JSON') unless $c->res->body;
}

1;
