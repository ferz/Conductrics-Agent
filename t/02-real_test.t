#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

my $env_found;
CHECK_ENV: {
    my @cvars = qw/ apikey ownerCode agent_name /;
    for my $v (@cvars) {
	unless (exists $ENV{"Conductrics_$v"}) {
	    plan skip_all=> join ("\n",
				  "\$ENV{Conductrics_$v} has to be defined for this test",
				  "environment vars required:",
				  map {"Conductrics_$_"} @cvars);
	    last CHECK_ENV;
	}
    }
    $env_found=1;
}

if ($env_found) {
    plan tests=>7;
}

use_ok('Conductrics::Agent');

my $agent = Conductrics::Agent->new(apiKey=>$ENV{Conductrics_apikey}, ownerCode=>$ENV{Conductrics_ownerCode}, baseUrl=>'http://api.conductrics.com/', name=>$ENV{Conductrics_agent_name});

ok($agent);
isa_ok($agent, "Conductrics::Agent");

my $decision1 = $agent->decide("123456789", qw/rosso giallo/);
ok($decision1, "decide()");
like($decision1, qr/giallo|rosso/ );

my $decision2 = $agent->decide("12345678900", qw/rosso giallo/);
ok($decision2, "decide()");
like($decision2, qr/giallo|rosso/ );

exit;
