package GrotSpot::Schema::DB::Result::AdvertClick;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("advert_clicks");
__PACKAGE__->add_columns(
    id         => {},
    created    => { data_type => 'datetime' },
    advert_id  => {},
    session_id => {},
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    advert => 'GrotSpot::Schema::DB::Result::Advert',
    { 'foreign.id' => 'self.advert_id' },
);

sub new {
    my ( $class, $attrs ) = @_;
    $attrs->{created} ||= DateTime->now();
    return $class->next::method($attrs);
}

1;

