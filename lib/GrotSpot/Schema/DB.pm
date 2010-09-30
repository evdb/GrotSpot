package GrotSpot::Schema::DB;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->connection(
    {
        dsn            => 'dbi:Pg:dbname=grotspot',
        user           => '',
        password       => '',
        pg_enable_utf8 => 1,
        AutoCommit     => 1,
    }
);

__PACKAGE__->load_namespaces( result_namespace => 'Result', );

1;
