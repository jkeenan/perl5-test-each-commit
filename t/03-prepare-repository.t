# t/03-prepare-repository.t
use 5.014;
use warnings;
use Perl5::TestEachCommit;
use Carp;
use File::Temp qw(tempfile tempdir);
use File::Spec::Functions;
use String::PerlIdentifier qw(make_varname);
use Test::More;
if( defined $ENV{SECONDARY_CHECKOUT_DIR} and
        -d $ENV{SECONDARY_CHECKOUT_DIR} ) {
        #plan 'no_plan';
    plan tests => 6;
}
else {
    plan skip_all => 'Could not locate git checkout of Perl core distribution';
}

use Data::Dump qw(dd pp);

# NOTE:  The tests in this file depend on having a git checkout of the Perl
# core distribution on disk.  We'll skip all if that is not the case.  If that
# is the case, then set the path to that checkout in the envvar
# SECONDARY_CHECKOUT_DIR; example:
#
#   export SECONDARY_CHECKOUT_DIR=/home/username/gitwork/perl2
#
# Perl5::TestEachCommit will detect that and default to it for 'workdir' --
# which is why we'll be able to omit it from calls to new() in this file.

my $opts = {
    #workdir => "/tmp",
    branch  => "blead",
    start   => "c9cd2e0cf4ad570adf68114c001a827190cb2ee9",
    end     => "0dfa8ac113680e6acdef0751168ab231b9bf842c",
    #configure_command => "sh ./Configure -des -Dusedevel",
    #make_test_harness_command => "make test_harness",
    #make_test_prep_command => "make test_prep",
    resultsdir => "/tmp",
    skip_test_harness => 1,
    verbose => 1,
};

my $self = Perl5::TestEachCommit->new( $opts );
ok($self, "new() returned true value");
isa_ok($self, 'Perl5::TestEachCommit',
    "object is a Perl5::TestEachCommit object");

my $rv = $self->prepare_repository();
ok($rv, "prepare_repository() returned true value");

{
    my $weird = make_varname(16);
    my %theseopts = map { $_=> $opts->{$_} } keys %$opts;
    $theseopts{branch} = $weird;
    chdir $ENV{SECONDARY_CHECKOUT_DIR}
        or croak "Unable to change to $ENV{SECONDARY_CHECKOUT_DIR}";
    my $rv = system(qq|git checkout -b $weird|)
        and croak "Unable to checkout $weird";

    my $self = Perl5::TestEachCommit->new( { %theseopts } );
    ok($self, "new() returned true value");
    isa_ok($self, 'Perl5::TestEachCommit',
        "object is a Perl5::TestEachCommit object");
    
    $rv = $self->prepare_repository();
    ok($rv, "prepare_repository() returned true value");

    $rv = system(qq|git checkout blead|)
        and croak "Unable to checkout blead";
    
    $rv = system(qq|git branch -d $weird|)
        and croak "Unable to delete branch '$weird'";
}
