package GrotSpot::Schema::DB::ResultSet::Advert;
use base 'DBIx::Class::ResultSet';

use strict;
use warnings;

sub enabled {
    my $rs = shift;
    return $rs->search( { enabled => 1 } );
}

1;
