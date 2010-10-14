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

    if ($advert) {
        $advert->record_view;

        # put it on the stash to display
        $c->stash->{advert} = $advert;
    }
}

sub go : Local {
    my ( $self, $c, $advert_id ) = @_;

    # sanitise the id
    $advert_id =~ s{\D+}{}g;
    $advert_id ||= 0;

    # load the advert or 404
    my $advert = $c->model("DB::Advert")->find($advert_id)
      || $c->detach('/page_not_found');

    # where did we come from
    my $referer = $c->req->referer || '';

    # record the click
    $c->session->{ads_clicked}++;
    $advert->record_click(
        {
            session_id => $c->sessionid,    #
            referer    => $referer,
        }
    );

    # redirect to the ad url
    $c->res->redirect( $advert->url );
}

1;
