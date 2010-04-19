#!perl
# -*- mode: sepia -*-
use Test::Simple tests => 2;
use List::Flatten::Recursive;
use v5.10;

#use Smart::Comments;

my @flat_list = ( 1..10 );
### @flat_list

my $circular_listref = [];
push @$circular_listref, 1..5, $circular_listref, 6..10;
### $circular_listref

# Now flatten!
my @flattened_circular_listref = List::Flatten::Recursive::flat($circular_listref);
### @flattened_circular_listref

# Test
ok( scalar(@flattened_circular_listref) == scalar(@flat_list),
    'flattened circular listref has correct length' );
ok( @flattened_circular_listref ~~ @flat_list,
    'flattened circular listref has correct contents' );
