package GrotSpot::Schema::DB::Result::Location;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("locations");
__PACKAGE__->add_columns(
    id      => {},
    created => { data_type => 'datetime' },
    lat     => {},
    lng     => {},
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( "locations_lat_lng_key", [ "lat", "lng" ] );

__PACKAGE__->has_many(
    ratings => 'GrotSpot::Schema::DB::Result::Rating',
    { 'foreign.location_id' => 'self.id' },
);

sub new {
    my ( $class, $attrs ) = @_;
    $attrs->{created} ||= DateTime->now();
    return $class->next::method($attrs);
}

sub average_score_raw {
    my $self = shift;
    my $avg = $self->ratings->get_column('score')->func('avg') || 0;
}

sub average_score {
    my $self = shift;
    my $avg  = $self->average_score_raw;
    return sprintf "%.1f", $avg;
}

1;

