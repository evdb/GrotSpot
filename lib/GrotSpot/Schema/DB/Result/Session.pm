package GrotSpot::Schema::DB::Result::Session;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("sessions");
__PACKAGE__->add_columns(
    id           => {},
    session_data => {},
    expires      => {},
    created      => { data_type => 'datetime' },
);

__PACKAGE__->set_primary_key("id");

sub new {
    my ( $class, $attrs ) = @_;

    $attrs->{created} ||= DateTime->now();

    return $class->next::method($attrs);
}

1;

