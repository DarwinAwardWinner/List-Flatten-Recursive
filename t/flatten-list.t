#!perl
# -*- mode: sepia -*-
use Test::Simple tests => 2;
use List::Flatten::Recursive;
use v5.10;

#use Smart::Comments;

my @flat_list = ( 1..10 );
### @flat_list

my @nonflat_list = (1, [2, 3], [4, [5, 6, [7,], 8, [9,]]], 10,);
### @nonflat_list

# Now flatten!
my @flattened_list = List::Flatten::Recursive::flat(@nonflat_list);
### @flattened_list

# Test
ok( scalar(@flattened_list) == scalar(@flat_list),
    'flattened list has correct length' );
ok( @flattened_list ~~ @flat_list,
    'flattened list has correct contents' );
