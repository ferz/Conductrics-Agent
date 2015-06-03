use strict;
use warnings;
use inc::Module::Install 0.91;
use Module::Install::Share;


if ( -e 'MANIFEST.SKIP' ) {
    system( 'pod2text lib/Conductrics/Agent.pm > README' );
}

perl_version '5.018002';
version_from 'lib/Conductrics/Agent.pm';

name 'Conductrics-Agent';
all_from 'lib/Conductrics/Agent.pm';

requires 'Modern::Perl'       => 0;
requires 'Moose'              => 0;
requires 'URI'                => 0;
requires 'MooseX::Types::Moose' => 0;
requires 'MooseX::Types::URI' => 0;
requires 'URI::QueryParam' => 0;
requires 'JSON::Any' => 0;
requires 'Time::HiRes' => 0;
requires 'LWP::UserAgent' => 0;

test_requires 'Test::More';

auto_install;
# resources repository => 'https://github.com/ferz/Conductrics-Agent';

makemaker_args(
    META_MERGE        => {
	"meta-spec" => { version => 2 },
	resources => {
	    repository => {
		type => 'git',
		url => 'git@github.com:ferz/Conductrics-Agent',
		web => 'https://github.com/ferz/Conductrics-Agent',
	    },
	},
    },
    );

WriteAll;
