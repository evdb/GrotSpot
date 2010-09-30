package GrotSpot::View::Web;

use strict;
use warnings;

use base 'Catalyst::View::TT';

use GrotSpot;

__PACKAGE__->config(
    INCLUDE_PATH       => [ GrotSpot->path_to('templates'), ],
    TEMPLATE_EXTENSION => '.html',
    render_die         => 1,
);

1;
