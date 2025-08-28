# t/02_util.t
use 5.014;
use warnings;
use Perl5::TestEachCommit;
#use Perl5::TestEachCommit::Util qw(
#    process_command_line
#    usage
#);
use Test::More tests => 2;
use Data::Dump qw(dd pp);
#use Capture::Tiny qw(capture_stderr);

my $opts = {
    branch => "blead",
    configure_command => "sh ./Configure -des -Dusedevel",
    end => "002",
    help => "",
    make_test_harness_command => "make test_harness",
    make_test_prep_command => "make test_prep",
    resultsdir => "/tmp",
    skip_test_harness => "",
    start => "001",
    verbose => "",
    workdir => "/tmp",
};
my $self = Perl5::TestEachCommit->new( $opts );
ok($self, "new() returned true value");
isa_ok($self, 'Perl5::TestEachCommit',
    "object is a Perl5::TestEachCommit object");
#pp($self);
