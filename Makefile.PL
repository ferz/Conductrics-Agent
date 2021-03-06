use strict;
use warnings;
use inc::Module::Install 0.91;
#use Module::Install::Share;

system( 'pod2text lib/Conductrics/Agent.pm > README' );
system( 'echo >> README "----"');
system( 'echo >> README "----"');
#system( 'pod2text lib/Conductrics/Client.pm >> README' );

if ( -e 'MANIFEST.SKIP' ) {
    system( 'pod2text lib/Conductrics/Agent.pm > README' );
    system( 'echo >> README "----"');
    system( 'echo >> README "----"');
#    system( 'pod2text lib/Conductrics/Client.pm >> README' );
}

perl_version '5.012000';
version_from 'lib/Conductrics/Agent.pm';

name 'Conductrics-Agent';
all_from 'lib/Conductrics/Agent.pm';
#all_from 'lib/Conductrics/Client.pm';

requires 'Moose'              => 0;
requires 'URI'                => 0;
requires 'MooseX::Types::Moose' => 0;
requires 'MooseX::Types::URI' => 0;
requires 'URI::QueryParam' => 0;
requires 'JSON::Any' => 0;
requires 'Time::HiRes' => 0;
requires 'LWP::UserAgent' => 0;

test_requires 'JSON::Schema';
test_requires 'Test::More';
test_requires 'Test::Deep::JSON';
test_requires 'Test::Deep';
test_requires 'JSON::MaybeXS';
test_requires 'Conductrics::Client';

auto_install;
# resources repository => 'https://github.com/ferz/Conductrics-Agent';

makemaker_args(
    META_MERGE        => {
	ABSTRACT => 'Perl interface for Conductrics universal optimization and reporting platform',
	"meta-spec" => { version => 2 },
	resources => {
	    repository => 'https://github.com/ferz/Conductrics-Agent'
	},
    },
    META_ADD => {
	resources => {
	    repository => 'https://github.com/ferz/Conductrics-Agent'
	},
    },
    );

WriteAll;
