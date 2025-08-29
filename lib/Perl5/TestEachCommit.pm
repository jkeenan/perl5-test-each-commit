package Perl5::TestEachCommit;
use 5.014;
use warnings;
our $VERSION = '0.01';
$VERSION = eval $VERSION;
use Carp;
use Data::Dump ( qw| dd pp| );
use Perl5::TestEachCommit::Util qw(
    process_command_line
);
#prepare_repository

=encoding utf8

=head1 NAME

Perl5::TestEachCommit - Test each commit in a pull request to Perl core

=head1 SYNOPSIS

    use Perl5::TestEachCommit;

    my $self = Perl5::TestEachCommit->new();

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 USAGE

TK

=head1 METHODS

=head2 C<new()>



=over 4

=item * Purpose

Perl5::TestEachCommit constructor.  Ensures that supplied arguments are
plausible, I<e.g.,> directories needed can be located.

=item * Arguments

    my $self = Perl5::TestEachCommit->new( { %opts } );

Single hash reference.  That hash B<must> include the following key-value pairs:

=over 4

#    "workdir=s"    => \$workdir,
#    "branch=s"    => \$branch,
#    "resultsdir=s"    => \$resultsdir,
#    "start=s"    => \$start_commit,
#    "end=s"    => \$end_commit,
#    "verbose"           => \$verbose,
#
#    "configure_command=s"    => \$configure_command,
#    "make_test_prep_command=s"    => \$make_test_prep_command,
#    "make_test_harness_command=s"    => \$make_test_harness_command,
#    "skip_test_harness" => \$skip_test_harness,

=back

In addition, that hash B<may> include the following key-value pairs:

=over 4

=back

=item * Return Value

Perl5::TestEachCommit object (blessed hash reference).

=item * Comment

TK

=back

=cut

#
#$workdir //= $ENV{SECONDARY_CHECKOUT_DIR};
#croak "Unable to locate workdir $workdir" unless -d $workdir;
#chdir $workdir or croak "Unable to change to $workdir";
#
#my $grv = system(qq|
#    git bisect reset && \
#    git clean -dfxq && \
#    git remote prune origin && \
#    git fetch origin && \
#    git checkout blead && \
#    git rebase origin/blead
#|) and croak "Unable to prepare $workdir for git activity";


sub new {
    my ($class, $params) = @_;
    my %data = map { $_ => $params->{$_} } keys %{$params};
    return bless \%data, $class;
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

