use strict;
use warnings;
use ExtUtils::MakeMaker;

eval "use ExtUtils::MakeMaker::Coverage";
if( !$@ ) {
    print "Adding testcover target\n";
}

WriteMakefile(
    NAME                => 'List::Flatten::Recursive',
    AUTHOR              => 'Ryan C. Thompson <rct@thompsonclan.org>',
    VERSION_FROM        => 'lib/List/Flatten/Recursive.pm',
    ABSTRACT_FROM       => 'lib/List/Flatten/Recursive.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'List-Flatten-Recursive-*' },
);
