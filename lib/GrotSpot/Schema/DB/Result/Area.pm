package GrotSpot::Schema::DB::Result::Area;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->table("areas");
__PACKAGE__->add_columns(
    id        => {},
    code      => {},
    name      => {},
    north_lat => {},
    west_lng  => {},
    south_lat => {},
    east_lng  => {},
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( "areas_code_key", ["code"] );
__PACKAGE__->add_unique_constraint( "areas_name_key", ["name"] );

# sub new {
#     my ( $class, $attrs ) = @_;
#     return $class->next::method($attrs);
# }

sub get_random_lat_lng {
    my $self = shift;

    my $lat_mag = $self->north_lat - $self->south_lat;
    my $lat     = $self->south_lat + rand() * $lat_mag;

    # FIXME - breaks across timeline
    my $lng_mag = $self->east_lng - $self->west_lng;
    my $lng     = $self->west_lng + rand() * $lng_mag;

    return ( $lat, $lng );
}

1;

