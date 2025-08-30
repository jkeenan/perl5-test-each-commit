# t/01-new.t
use 5.014;
use warnings;
use Perl5::TestEachCommit;
use File::Temp qw(tempfile tempdir);
use File::Spec::Functions;
use Test::More qw(no_plan); # tests => 2;
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

note("Error Conditions in new()");

{
    local $@;
    my %theseopts = map { $_ => $opts->{$_} } keys %{$opts};
    delete $theseopts{start};
    my $self;
    eval { $self = Perl5::TestEachCommit->new( \%theseopts ); };
    like($@,
        qr/Must supply SHA of first commit to be studied to 'start'/,
        "Got exception for lack of 'start'"); 
}

{
    local $@;
    my %theseopts = map { $_ => $opts->{$_} } keys %{$opts};
    delete $theseopts{end};
    my $self;
    eval { $self = Perl5::TestEachCommit->new( \%theseopts ); };
    like($@,
        qr/Must supply SHA of last commit to be studied to 'end'/,
        "Got exception for lack of 'end'"); 
}

{
    local $@;
    my %theseopts = map { $_ => $opts->{$_} } keys %{$opts};
    delete $theseopts{workdir};
    local $ENV{SECONDARY_CHECKOUT_DIR} = undef;
    my $self;
    eval { $self = Perl5::TestEachCommit->new( \%theseopts ); };
    like($@,
        qr/Unable to locate workdir/,
        "Got exception for lack of for 'workdir'"); 
}

{
    local $@;
    my %theseopts = map { $_ => $opts->{$_} } keys %{$opts};
    delete $theseopts{resultsdir};
    local $ENV{P5P_DIR} = undef;
    my $self;
    eval { $self = Perl5::TestEachCommit->new( \%theseopts ); };
    like($@,
        qr/Unable to locate resultsdir/,
        "Got exception for lack of for 'resultsdir'"); 
}

{
    my %theseopts = map { $_ => $opts->{$_} } keys %{$opts};
    delete $theseopts{branch};
    delete $theseopts{configure_command};
    delete $theseopts{make_test_prep_command};
    delete $theseopts{make_test_harness_command};
    my $self = Perl5::TestEachCommit->new( \%theseopts );
    is($self->{branch}, 'blead', "'branch' defaulted to blead");
    is($self->{configure_command}, 'sh ./Configure -des -Dusedevel',
        "'configure_command' set to default");
    is($self->{make_test_prep_command}, 'make test_prep',
        "'make_test_prep_command' set to default");
    is($self->{make_test_harness_command}, 'make test_harness',
        "'make_test_harness_command' set to default");
}

