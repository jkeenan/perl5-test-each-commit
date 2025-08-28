package Perl5::TestEachCommit::Util;
use 5.014;
use Exporter 'import';
use File::Spec;
use File::Spec::Unix;
use locale; # make \w work right in non-ASCII lands

# Adapted from:
# ~/gitwork/perl/ext/Pod-Html/lib/Pod/Html/Util.pm

our $VERSION = 0.01; # Please keep in synch with lib/Pod/Html.pm
$VERSION = eval $VERSION;
our @EXPORT_OK = qw(
    process_command_line
    prepare_repository
);

=head1 NAME

Perl5::TestEachCommit::Util - helper functions for Pod-Html

=head1 SUBROUTINES

# B<Note:> While these functions are importable on request from
# F<Perl5::TestEachCommit::Util>, they are specifically intended for use within (a) the
# F<Pod-Html> distribution (modules and test programs) shipped as part of the
# Perl 5 core and (b) other parts of the core such as the F<installhtml>
# program.  These functions may be modified or relocated within the core
# distribution -- or removed entirely therefrom -- as the core's needs evolve.
# Hence, you should not rely on these functions in situations other than those
# just described.

=cut

=head2 C<process_command_line()>

Process command-line switches (options).  Returns a reference to a hash.  Will
provide usage message if C<--help> switch is present or if parameters are
invalid.

Calling this subroutine may modify C<@ARGV>.

=cut

sub process_command_line {
#    my %opts = map { $_ => undef } (qw|
#        backlink cachedir css flush
#        header help htmldir htmlroot
#        index infile outfile poderrors
#        podpath podroot quiet recurse
#        title verbose
#    |);
#    unshift @ARGV, split ' ', $Config{pod2html} if $Config{pod2html};
#    my $result = GetOptions(\%opts,
#        'backlink!',
#        'cachedir=s',
#        'css=s',
#        'flush',
#        'help',
#        'header!',
#        'htmldir=s',
#        'htmlroot=s',
#        'index!',
#        'infile=s',
#        'outfile=s',
#        'poderrors!',
#        'podpath=s',
#        'podroot=s',
#        'quiet!',
#        'recurse!',
#        'title=s',
#        'verbose!',
#    );
#    usage("-", "invalid parameters") if not $result;
#    usage("-") if defined $opts{help};  # see if the user asked for help
#    $opts{help} = "";                   # just to make -w shut-up.
#    return \%opts;
}

1;

