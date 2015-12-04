package SWISH::Filters::Doc2html;
use strict;
use vars qw( $VERSION @ISA );
$VERSION = '0.20';
@ISA = ('SWISH::Filters::Base');

sub new {
    my ($class) = @_;

    my $self = bless { mimetypes => [qr!application/(x-)?msword!], }, $class;

    return $self->set_programs('wvWare');
}

sub filter {
    my ( $self, $doc ) = @_;

    # Grab output from running program
    my $content = $self->run_wvWare( "-1", $doc->fetch_filename ) || return;

    my $meta = $doc->meta_data || {};
    my $headers = $self->format_meta_headers($meta);

    if ( $content =~ m/<head>/i ) {
        $content =~ s/<head>/<head>$headers/i;
    }
    else {
        $content =~ s/<title>/$headers\n<title>/i;
    }

    # update the document's content type
    $doc->set_content_type('text/html');

    # return the document
    return ( \$content, $meta );
}
1;

__END__

=head1 NAME

SWISH::Filters::Doc2html - Perl extension for filtering MSWord documents
with Swish-e

=head1 DESCRIPTION

This is a plug-in module that uses the "wvware" program to convert MS Word
documents to HTML for indexing by Swish-e.  "wvware" can be downloaded from:

    http://wvware.sourceforge.net/

The program "wvware" must be installed and in your PATH before running Swish-e.
This has been tested only under Win32- binary package from
http://gnuwin32.sourceforge.net/packages/wv.htm

Tested with Debian Linux and wvWare wvWare 0.7.3.


=head1 SEE ALSO

L<SWISH::Filter>
