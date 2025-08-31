package Perl5::TestEachCommit;
use 5.014;
use warnings;
our $VERSION = '0.01';
$VERSION = eval $VERSION;
use Carp;
use Data::Dump ( qw| dd pp| );
use File::Spec::Functions;
use Perl5::TestEachCommit::Util qw(
    process_command_line
);

=encoding utf8

=head1 NAME

Perl5::TestEachCommit - Test each commit in a pull request to Perl core

=head1 SYNOPSIS

    use Perl5::TestEachCommit;

    my $self = Perl5::TestEachCommit->new();

=head1 DESCRIPTION

This library is intended for use by people working to maintain the L<Perl core
distribution|https://github.com/Perl/perl5>.

=head1 METHODS

=head2 C<new()>

=over 4

=item * Purpose

Perl5::TestEachCommit constructor.  Ensures that supplied arguments are
plausible, I<e.g.,> directories needed can be located.

=item * Arguments

    my $self = Perl5::TestEachCommit->new( { %opts } );

Single hash reference.  That hash B<must> include the following key-value
pairs:

=over 4

* C<workdir>

String holding path to a directory which is a F<git> checkout of the Perl core
distribution.  If you have previously set an environmental variable
C<SECONDARY_CHECKOUT_DIR> to such a directory, that will be used; otherwise,
path must be specified. (MODIFY)

* C<resultsdir>

String holding path to a directory in which any non-temporary files generated
by use of this library can be created.  If you have previously set an
environmental variable C<P5P_DIR> to such a directory, that will be used;
otherwise, path must be specified. (MODIFY)

* C<start>

String holding SHA of the first commit in the series on which you wish
reporting.

* C<end>

String holding SHA of the last commit in the series on which you wish
reporting.

=back

In addition, that hash B<may> include the following key-value pairs:

=over 4

* C<branch>

F<git> branch which must exist and be available for C<git checkout> in the
directory specified by C<workdir>.  Defalults to C<blead>.

* C<configure_command>

String holding arguments to be passed to F<./Configure>.
Defaults to C<sh ./Configure -des -Dusedevel>.

* C<make_test_prep_command>

String holding arguments to be passed to F<make test_prep>.
Defaults to C<make test_prep>.

* C<make_test_harness_command>

String holding arguments to be passed to F<make test_harness>.
Defaults to C<make test_harness>.

* C<skip_test_harness>

True/false value.  Defaults to false.  If true, when proceeding through a
series of commits in a branch or pull request, the C<make test_harness> stage
is skipped on the assumption that any significant failures are going to appear
in the first two stages.

* C<verbose>

True/false value.  Defaults to false.  If true, prints to STDOUT a summary of
switches in use and commits being tested.

=back

=item * Return Value

Perl5::TestEachCommit object (blessed hash reference).

=item * Comment

TK

=back

=cut

sub new {
    my ($class, $params) = @_;
    my $args = {};
    for my $k (keys %{$params}) { $args->{$k} = $params->{$k}; }
    my %data;
    croak "Must supply SHA of first commit to be studied to 'start'"
        unless $args->{start};
    croak "Must supply SHA of last commit to be studied to 'end'"
        unless $args->{end};
    $data{start} = delete $args->{start};
    $data{end} = delete $args->{end};

    # workdir: First see if it has been assigned and exists
    # later: see whether it is a git checkout (and of perl)
    $args->{workdir} //= ($ENV{SECONDARY_CHECKOUT_DIR} || '');
    -d $args->{workdir} or croak "Unable to locate workdir in $args->{workdir}";
    $data{workdir} = delete $args->{workdir};

    $args->{resultsdir} //= ($ENV{P5P_DIR} || '');
    -d $args->{resultsdir}
        or croak "Unable to locate resultsdir in $args->{resultsdir}";
    $data{resultsdir} = delete $args->{resultsdir};

    $data{branch} = $args->{branch} ? delete $args->{branch} : 'blead';
    $data{configure_command} = $args->{configure_command}
        ? delete $args->{configure_command}
        : 'sh ./Configure -des -Dusedevel';
    $data{make_test_prep_command} = $args->{make_test_prep_command}
        ? delete $args->{make_test_prep_command}
        : 'make test_prep';
    $data{make_test_harness_command} = $args->{make_test_harness_command}
        ? delete $args->{make_test_harness_command}
        : 'make test_harness';

    $data{skip_test_harness} = defined $args->{skip_test_harness}
        ? delete $args->{skip_test_harness}
        : '';
    $data{verbose} = defined $args->{verbose}
        ? delete $args->{verbose}
        : '';

    # Double-check that every parameter ultimately gets into the object with
    # some assignment.
    map { ! exists $data{$_} ?  $data{$_} = $args->{$_} : '' } keys %{$args};
    return bless \%data, $class;
}

#    croak "$args->{workdir} is not a git checkout"
#        unless -d catdir($args->{workdir}, '.git');

=head2 C<prepare_repository()>

=over 4

=item * Purpose

Prepare the C<workdir> directory for F<git> operations, I<e.g.,> terminates
any bisection in process, cleans the directory, fetches from origing, checks
out blead, then checks out any non-blead branch provided in the C<branch>
argument to C<new()>.

=item * Arguments

None.

    my $rv = $self->prepare_repostory();

=item * Return Value

Returns true value upon success.

=item * Comment

TK

=back

=cut

sub prepare_repository {
    my $self = shift;

    chdir $self->{workdir} or croak "Unable to change to $self->{workdir}";

    my $grv = system(qq|
        git bisect reset && \
        git clean -dfxq && \
        git remote prune origin && \
        git fetch origin && \
        git checkout blead && \
        git rebase origin/blead
    |) and croak "Unable to prepare $self->{workdir} for git activity";

    if ($self->{branch} ne 'blead') {
        system(qq|git checkout $self->{branch}|)
            and croak "Unable to checkout branch '$self->{branch}'";
    }
    return 1;
}

=head2 C<report_plan()>

=over 4

=item * Purpose

Display most important configuration choices.

=item * Arguments

    $self->report_plan();

=item * Return Value

Implicitly returns true value upon success.

=item * Comment

TK

=back

=cut

sub report_plan {
    my $self = shift;
    say "branch:                    $self->{branch}";
    say "configure_command:         $self->{configure_command}";
    say "make_test_prep_command:    $self->{make_test_prep_command}";
    if ($self->{skip_test_harness}) {
        say "Skipping 'make test_harness'";
    }
    else {
        say "make_test_harness_command: $self->{make_test_harness_command}";
    }
    return 1;
}

=head2 C<get_commits()>

=over 4

=item * Purpose

Get a list of SHAs of all commits being tested.

=item * Arguments

    my $lines = $self->get_commits();

=item * Return Value

Reference to an array holding list of all commits being tested.

=item * Comment

TK

=back

=cut

sub get_commits {
    my $self = shift;
    my $origin_commit = $self->{start} . '^';
    my $end_commit = $self->{end};
    my @commits = `git rev-list --reverse ${origin_commit}..${end_commit}`;
    chomp @commits;
    return \@commits;
}

=head2 C<display_commits()>

=over 4

=item * Purpose

Display a list of SHAs of all commits being tested.

=item * Arguments

    $self->display_commits();

=item * Return Value

Implicitly returns true value upon success.

=item * Comment

TK

=back

=cut

sub display_commits {
    my $self = shift;
    #dd $self->get_commits();
    say $_ for @{$self->get_commits()};
    return 1;
}

=head1 BUGS

TK

=head1 SUPPORT

TK

=head1 AUTHOR

    James E Keenan
    CPAN ID: JKEENAN
    jkeenan@cpan.org
    https://thenceforward.net/perl/modules/Perl5-TestEachCommit

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

perl(1).

=cut

1;
# The preceding line will help the module return a true value

