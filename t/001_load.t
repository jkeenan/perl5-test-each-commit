# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 3;

BEGIN {
    use_ok( 'Perl5::TestEachCommit' );
    use_ok( 'Perl5::TestEachCommit::Util' );
}

my $object = Perl5::TestEachCommit->new({});
isa_ok ($object, 'Perl5::TestEachCommit');


