package List::Flatten::Recursive;

use v5.10;
use warnings;
use strict;
use Carp;
use utf8;
use autodie qw( :all );
use Data::Alias;
use List::Flatten ();
use List::MoreUtils qw( any );

#use Smart::Comments;

use version; our $VERSION = qv('0.0.1');

require Exporter;
use base qw(Exporter);
our @EXPORT = qw( flat );

sub flat {
    my @list = reverse @_;

    my @flatlist;

    my %seen;
    $seen{\@_}++;
    ### Just saw: +\@_
    while (@list) {
        my $subject = pop @list;
        if (ref $subject eq 'ARRAY') {
            # Subject is a listref
            alias my $listref = $subject;
            # Skip if seen
            if ($seen{$listref}) {
                ### Already saw: +$listref
                next;
            }
            else {
                # Flatten unseen listref and return it in reverse to
                # the stack
                $seen{$listref}++;
                ### Just saw: +$listref
                push @list, reverse @$listref;
            }
        }
        else {
            # Subject is a regular thing (not a listref)
            push @flatlist, $subject;
        }
    }
    return @flatlist;

    # ### Begin flattening...
    # return _flat( \@_ );
}

1; # Magic true value required at end of module
__END__

=head1 NAME

List::Flatten::Recursive - List::Flatten with recursion


=head1 VERSION

This document describes List::Flatten::Recursive version 0.0.1


=head1 SYNOPSIS

    use List::Flatten::Recursive qw( flat );

    my $crazy_listref = [ 1, [ 2, 3 ], [ [ [ 4 ] ] ] ];
    flat($crazy_listref); # Yields (1,2,3,4)
    push @$crazy_listref, $crazy_listref; # Now it contains itself!
    List::Flatten::Recursive::flat($crazy_listref); # Still yields (1,2,3,4)



=head1 DESCRIPTION

If you think of nested lists as a tree structure (an in Lisp, for
example), then B<flat> basically returns all the leaf nodes from an
inorder tree traversal, and leaves out the internal nodes (i.e.
listrefs).

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE

=head2 flat

B<Arguments:> a list or listref

B<Returns:> the same list, with each array reference replaced by the
contents of the list to which it refers.

Unlike B<List::Flatten::flat>, this function works recursively. Array
references within array references are interpolated. Circular
references are detected, and a circular reference interpolates to an
empty list (that is, it it omitted).

Note that B<flat> always returns a list. Even if you call it on a scalar, it returns a one-element list containing that scalar. This is because it is impossible to disambiguate the following:

    # Call on a scalar
    flat( 1 );

    # Call on a one-element list:
    flat( (1) );

In principle, B<flat> could be modified to return a scalar instead of a one-element list in scalar context, but that would defeat the C<scalar(@list)> idiom for counting the number of elements in a list.

B<flat> is exported only by request.

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.

List::Flatten::Recursive requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

If two elements of a list are both references to the same list, then
the second reference will be ignored, even though the result is not a
circular reference. That is, C<flat> only flattens a spanning tree of
its input. If this is a problem. Bug the author and he will fix it.

Please report any bugs or feature requests to
C<rct+perlbug@thompsonclan.org>.


=head1 AUTHOR

Ryan C. Thompson  C<< <rct@thompsonclan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Ryan C. Thompson C<< <rct@thompsonclan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
