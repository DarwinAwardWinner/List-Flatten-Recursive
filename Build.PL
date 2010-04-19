use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'List::Flatten::Recursive',
    license             => 'perl',
    dist_author         => 'Ryan C. Thompson <rct@thompsonclan.org>',
    dist_version_from   => 'lib/List/Flatten/Recursive.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'List-Flatten-Recursive-*' ],
);

$builder->create_build_script();
