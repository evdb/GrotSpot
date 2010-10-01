package GrotSpot::Schema::DB::Result::Email;
use base 'DBIx::Class::Core';

use strict;
use warnings;

use DateTime;

__PACKAGE__->table("emails");
__PACKAGE__->add_columns(
    id    => {},
    email => {},
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( "emails_email_key", ["email"] );

__PACKAGE__->has_many(
    ratings => 'GrotSpot::Schema::DB::Result::Rating',
    { 'foreign.email_id' => 'self.id' },
);

1;

