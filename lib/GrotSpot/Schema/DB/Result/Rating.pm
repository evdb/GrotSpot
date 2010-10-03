package GrotSpot::Schema::DB::Result::Rating;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("ratings");
__PACKAGE__->add_columns(
    id          => {},
    created     => { data_type => 'datetime' },
    location_id => {},
    session_id  => {},
    email_id    => {},
    score       => {},
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    email => 'GrotSpot::Schema::DB::Result::Email',
    { 'foreign.id' => 'self.email_id' },
);

__PACKAGE__->belongs_to(
    location => 'GrotSpot::Schema::DB::Result::Location',
    { 'foreign.id' => 'self.location_id' },
);

sub new {
    my ( $class, $attrs ) = @_;
    $attrs->{created} ||= DateTime->now();
    return $class->next::method($attrs);
}

1;

