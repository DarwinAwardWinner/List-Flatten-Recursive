#!perl
# -*- mode: sepia -*-
use Test::Simple tests => 2;
use List::Flatten::Recursive;
use v5.10;

#use Smart::Comments;

my @flat_list = ( 1..10 );
### @flat_list

my $nonflat_listref = [ 1, [2, 3], [4, [5, 6, [7,], 8, [9,]]], 10, ];
### $nonflat_listref

# Now flatten!
my @flattened_listref = List::Flatten::Recursive::flat($nonflat_listref);
### @flattened_listref

# Test
ok( scalar(@flattened_listref) == scalar(@flat_list),
    'flattened listref has correct length' );
ok( @flattened_listref ~~ @flat_list,
    'flattened listref has correct contents' );
