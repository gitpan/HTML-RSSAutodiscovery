{

=head1 NAME

HTML::RSSAutodiscovery - methods for retreiving RSS-ish information from an HTML document.

=head1 SYNOPSIS

 use HTML::RSSAutodiscovery;
 use Data::Dumper;

 my $url = "http://www.diveintomark.org/";

 my $html = HTML::RSSAutodiscovery->new();
 print &Dumper($html->parse($url));

 # Mark's gone a bit nuts with this and
 # the list is too long to include here...

=head1 DESCRIPTION

Methods for retreiving RSS-ish information from an HTML document.

=cut

package HTML::RSSAutodiscovery;
use strict;

use Exporter;
use LWP::UserAgent;
use HTTP::Request;
use HTML::Parser;

$HTML::RSSAutodiscovery::VERSION   = '1.0';

@HTML::RSSAutodiscovery::ISA       = qw (Exporter HTML::Parser);
@HTML::RSSAutodiscovery::EXPORT    = qw ();
@HTML::RSSAutodiscovery::EXPORT_OK = qw ();

=head1 OBJECT METHODS

=head2 $pkg = HTML::RSSAutodiscovery->new()

Object constructor. Returns an object. Woot!

=cut

sub new {
    my $pkg = shift;

    my $self = {};
    bless $self,$pkg;

    if (! $self->init(@_)) {
        return undef;
    }

    return $self;
}

sub init {
  my $self = shift;
  $self->SUPER::init(start_h=> [\&_start,"self,tagname,attr"]);
  return 1;
}

=head2 $pkg->parse($arg)

Parse an HTML document and return RSS-ish &lt;link> information.

I<$arg> may be either:

=over

=item *

An HTML string, passed as a scalar reference.

=item *

A URI.

=back

Returns an array reference of hash references whose keys are :

=over

=item *

I<title>

=item *

I<type>

=item *

I<rel>

=item *

I<href>

=back

=cut

sub parse {
  my $self = shift;
  my $data = shift;

  if (ref($data) ne "SCALAR") {
    $data = $self->_fetch($data) || return undef;
  }

  $self->{'__links'} = [];

  $self->SUPER::parse($$data);
  return $self->{'__links'};
}

sub _fetch {
  my $self = shift;
  my $uri  = shift;

  $self->{'__ua'} ||= LWP::UserAgent->new();
  
  my $res = $self->{'__ua'}->request(HTTP::Request->new(GET=>$uri));

  if (! $res->is_success()) {
    return undef;
  }

  return \$res->content();
}

sub _start {

  if ($_[1] ne "link") {
    return;
  }

  if ($_[2]->{'name'} =~ /^(XML|RSS)$/) {
    return;
  }
  if (($_[2]->{'type'} ne "application/rss+xml") &&
      ($_[2]->{'type'} ne "text/xml")) {
    return;
  }

  push @{$_[0]->{'__links'}},$_[2];
}

=head1 VERSION

1.0

=head1 DATE

June 03, 2002

=head1 AUTHOR

Aaron Straup Cope

=head1 SEE ALSO

http://diveintomark.org/archives/2002/05/30.html#rss_autodiscovery

=head1 LICENSE

Copyright (c) 2002, Aaron Straup Cope. All Rights Reserved.

This is free software, you may use it and distribute it under the same terms as Perl itself.

=cut

return 1;

}
