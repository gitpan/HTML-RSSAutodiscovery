use strict;

BEGIN { $| = 1; print "1..1\n"; }

use HTML::RSSAutodiscovery;
use Data::Dumper;

my $url = "http://www.diveintomark.org/";
my $html = undef;

if (&t2(&t1())) {
  print "Passed all tests\n";
}

sub t1 {
  $html = HTML::RSSAutodiscovery->new();

  if (! $html) {
    print "not ok 1\n";
    return 0;
  }

  print "ok 1\n";
  return 1;
}

sub t2 {
  my $last = shift;

  if (! $last) {
    print "not ok 2\n";
    return 0;
  }

  my $links = undef;

  eval { $links = $html->parse($url); };

  if ($@) {
    print $@,"\n";
    print "not ok 2\n";
    return 0;
  }

  print &Dumper($links);

  print "ok 1\n";
  return 1;
}



