package GrotSpot::Schema::DB::Result::Location;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->table("locations");
__PACKAGE__->add_columns(
    id  => {},
    lat => {},
    lng => {},
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( "locations_lat_lng_key", [ "lat", "lng" ] );

__PACKAGE__->has_many(
    ratings => 'GrotSpot::Schema::DB::Result::Rating',
    { 'foreign.location_id' => 'self.id' },
);

1;

