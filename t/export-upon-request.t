#!perl
use Test::More;
# use Test::More tests => 3;
use List::Flatten::Recursive qw( flatten_to_listref );
no warnings;

ok( !defined(&flat),
    "Don't export `flat' when other stuff is requested." );
ok( defined(&flatten_to_listref),
    "Export `flatten_to_listref' upon request." );

done_testing();
