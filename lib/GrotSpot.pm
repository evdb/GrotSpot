package GrotSpot;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

use parent qw/Catalyst/;
use Catalyst (    #
    'ConfigLoader',      #
    'Static::Simple',    #
    'Unicode',           #
    'Compress::Gzip',
    'SessionHP::State::Cookie',
    'Session::Store::DBIC',
    'SessionHP',
);

our $VERSION = '0.02';

__PACKAGE__->config(
    name              => 'GrotSpot',
    'Plugin::Session' => {
        dbic_class   => 'DB::Session',
        expires      => 3600 * 24 * 365,    # 1 year
        max_lifetime => 3600 * 24 * 2,      # 2 days
        min_lifetime => 3600 * 24 * 1,      # 1 day
    },
    default_view => 'Web',
    grotspot     => {

        show_adverts  => 1,
        show_feedback => 1,
        show_facebook => 1,

        affiliate_codes => {                #
            amazon_uk => 'grot09-21',
        },
    },

);

__PACKAGE__->setup();

# FIXME - should be in a better place
sub future_discount {
    my $c = shift;
    my $ratings = shift || 0;

    my $discount = 0;

    my %discounts = (
        1    => 5,
        5    => 10,
        20   => 20,
        100  => 30,
        500  => 40,
        1000 => 50,
    );

    foreach my $ratings_needed ( sort { $a <=> $b } keys %discounts ) {
        $discount = $discounts{$ratings_needed} if $ratings >= $ratings_needed;
    }

    return $discount;
}

1;
