package GrotSpot::Schema::DB::Result::Advert;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("adverts");
__PACKAGE__->add_columns(
    id          => {},
    created     => { data_type => 'datetime' },
    enabled     => {},
    heading     => {},
    blurb       => {},
    price       => {},
    url         => {},
    image_url   => {},
    view_count  => {},
    click_count => {},
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    clicks => 'GrotSpot::Schema::DB::Result::AdvertClick',
    { 'foreign.advert_id' => 'self.id' },
);

sub new {
    my ( $class, $attrs ) = @_;
    $attrs->{created}     ||= DateTime->now();
    $attrs->{enabled}     ||= 1;
    $attrs->{view_count}  ||= 0;
    $attrs->{click_count} ||= 0;
    return $class->next::method($attrs);
}

1;

