use strict;
use Test::More;

eval "require XMLRPC::Lite";

if ($@) {
   plan tests => "none";
   exit;
}

plan tests => 5;

my $url   = "macnn.com";
my $links = undef;
my $count = undef;

use_ok("HTML::RSSAutodiscovery");

my $html = HTML::RSSAutodiscovery->new();

isa_ok($html,"HTML::RSSAutodiscovery");

eval { $links = $html->locate($url,{syndic8=>1}); };
is($@,'',"Parsed $url");

cmp_ok(ref($links),"eq","ARRAY");

$count = scalar(@$links);
cmp_ok($count,">",0,"$count feed(s)");


