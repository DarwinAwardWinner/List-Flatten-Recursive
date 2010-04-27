#!perl
# -*- mode: sepia -*-
use Test::Simple tests => 2;
use List::Flatten::Recursive;
use v5.10;

#use Smart::Comments;

my @flat_list_of_one = ( 1 );
my $scalar = 1;

# Now flatten!
my @flattened_list = List::Flatten::Recursive::flat($scalar);
### @flattened_list

# Test
ok( scalar(@flattened_list) == scalar(@flat_list_of_one),
    'flattened list has correct length' );
ok( @flattened_list ~~ @flat_list_of_one,
    'flattened list has correct contents' );
