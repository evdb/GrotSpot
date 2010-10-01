package GrotSpot::Schema::DB::Result::Location;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("locations");
__PACKAGE__->add_columns(
    id        => {},
    code      => {},
    name      => {},
    north_lat => {},
    west_lon  => {},
    south_lat => {},
    east_lon  => {},
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( "locations_code_key", ["code"] );
__PACKAGE__->add_unique_constraint( "locations_name_key", ["name"] );

# sub new {
#     my ( $class, $attrs ) = @_;
#     return $class->next::method($attrs);
# }

sub get_random_lat_lon {
    my $self = shift;

    my $lat_mag = $self->north_lat - $self->south_lat;
    my $lat     = $self->south_lat + rand() * $lat_mag;

    # FIXME - breaks across timeline
    my $lon_mag = $self->east_lon - $self->west_lon;
    my $lon     = $self->west_lon + rand() * $lon_mag;

    return ( $lat, $lon );
}

1;

