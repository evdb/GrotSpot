package GrotSpot::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

__PACKAGE__->config(
    # allow_callback => 1,
    # callback_param => 'json_callback',
    expose_stash   => 'json_data',
);

1;
