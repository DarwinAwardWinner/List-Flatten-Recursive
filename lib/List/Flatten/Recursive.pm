use strict;
use warnings;
use v5.10;
use utf8;

package List::Flatten::Recursive;
# ABSTRACT: List::Flatten with recursion

require Exporter::Simple;
use base qw(Exporter::Simple);

use List::MoreUtils qw(any);

sub _flat {
    # Args: first arg is thing to flatten,
    # rest are already seen lists
    my $list = shift;
    my @seen_lists = @_;

    if (ref $list ne 'ARRAY') {
        # Already flat (i.e. leaf node)
        # $list is not really a list, so just return it
        return $list;
    }
    elsif (any { $_ == $list } @seen_lists) {
        # Already recursed into this list, so skip it this time
        return;
    }
    else {
        # New list: Add $list to @seen_lists, then dereference and recurse
        push @seen_lists, $list;
        return map { _flat($_, @seen_lists) } @{$list};
    }
}

=method flat

This method flattens a list (or listref) recursively. It takes a list
that may contain other sublists, and replaces those sublists with
their contents, recursively, until the list no longer contains any
sublists.

C<flat> makes a best effort to break circular references (that is,
lists that contain references to themselves), and should never enter
an infinite recursion.

This method is exported by default.

=cut

sub flat : Exported {
    return _flat(\@_);
}

=method flatten_to_listref

Same as C<flat>, but returns a single reference to the resulting list.

This method is exported only by request. To use this method, put the following at the top of your program:

    use List::Flatten::Recursive qw( flatten_to_listref );

=cut

sub flatten_to_listref : Exportable {
    return [ flat(@_) ];
}

1; # Magic true value required at end of module
__END__

=head1 SYNOPSIS

    use List::Flatten::Recursive qw( flat );

    my $crazy_listref = [ 1, [ 2, 3 ], [ [ [ 4 ] ] ] ];
    flat($crazy_listref); # Yields (1,2,3,4)
    push @$crazy_listref, $crazy_listref; # Now it contains itself!
    flat($crazy_listref); # Still yields (1,2,3,4)
    flat([ $crazy_listref ]); # Ditto.

    # But don't do this.
    flat(@$crazy_listref); # Will not yield the same as above.

=head1 DESCRIPTION

If you think of nested lists as a tree structure (an in Lisp, for
example), then C<flat> basically returns all the leaf nodes from an
inorder tree traversal, and leaves out the internal nodes (i.e.
listrefs). If the nested list is a DAG instead of just a tree, it
should still flatten correctly (based on my own definition of
correctness, of course; see also t/flatten-dag.t).

If the nested list is self-referential, then any cycles will be broken
by replacing ancestor references with empty lists. However, the only
behavior you should rely on when flattening a self-referential data
structure is that infinite recursion should not occur, and each
non-list element in the data structure should appear at least once in
the output.

=head1 BUGS AND LIMITATIONS

=head2 Self-referential lists should be flattened by reference

If you are going to flatten a list which may contain references to
itself, you should pass a reference to that list to C<flat>, or else
things will not work the way you expect. You will end up with an extra
trip around the circle before the circular reference is caught.

=head2 C<flat> always returns a list

Even if you call C<flat> on a single scalar, it will still return a
list with one element in it. If called in scalar context, it will
return the length of that list. C<flatten_to_listref> would return a
reference to a list with one element. There is no case where the
original scalar would be returned directly. This is by design. If you
think this is wrong, email me and tell me why.

Please report any bugs or feature requests to
C<rct+perlbug@thompsonclan.org>. If you find a case where this module
returns what you feel is a wrong result, please send an example that
will cause it to do so, along with the actual and expected results.

=head1 SEE ALSO

=for :list
* L<List::Flatten>

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
