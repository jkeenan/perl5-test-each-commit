# t/01_load.t
use 5.014;
use warnings;
use Test::More qw(no_plan); # tests => 3;
use Perl5::TestEachCommit;

my $object = Perl5::TestEachCommit->new({});
isa_ok ($object, 'Perl5::TestEachCommit');


