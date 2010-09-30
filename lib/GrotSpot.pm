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

our $VERSION = '0.01';

__PACKAGE__->config(
    name              => 'GrotSpot',
    'Plugin::Session' => {
        dbic_class   => 'DB::Session',
        expires      => 3600 * 24 * 365,    # 1 year
        max_lifetime => 3600 * 24 * 2,      # 2 days
        min_lifetime => 3600 * 24 * 1,      # 1 day
    },
);

__PACKAGE__->setup();

1;
