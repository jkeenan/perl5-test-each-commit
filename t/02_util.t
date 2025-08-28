# t/02_util.t
use 5.014;
use warnings;
use Perl5::TestEachCommit::Util qw(
    process_command_line
    usage
);
use Test::More qw(no_plan); # tests => 3;
use Data::Dump qw(dd pp);
use Capture::Tiny qw(capture_stderr);

my $opts = process_command_line();
is(ref($opts), 'HASH', "process_command_line returned a hashref");

{
    local @ARGV = (
        workdir     => '/tmp',
        branch      => 'blead',
        resultsdir  => '/tmp',
        start       => '001',
        end         => '002',
        verbose     => 0,
        configure_command       => 'sh ./Configure -des -Dusedevel',
        make_test_prep_command  => 'make test_prep',
        make_test_harness_command   => 'make test_harness',
        skip_test_harness => 0,
    );
    my $opts = process_command_line();
    is(ref($opts), 'HASH', "process_command_line returned a hashref");
    #pp $opts;
}

{
    local @ARGV = ( help    => 1 );
    my $opts;
    my $stderr = capture_stderr {
        $opts = process_command_line();
    };
    is(ref($opts), 'HASH', "process_command_line returned a hashref");
    my @lines = split /\n/, $stderr;
    like($lines[0], qr/^Usage:/, "usage statement executed");
}

