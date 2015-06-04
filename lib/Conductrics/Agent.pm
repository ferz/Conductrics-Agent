package Conductrics::Agent;

use strict;
use warnings;
use Modern::Perl;
use namespace::autoclean;
use Moose;
use MooseX::Types::Moose qw( Str );
use MooseX::Types::URI qw(Uri);
use URI;
use URI::QueryParam;
use JSON::Any;
use Time::HiRes;

require LWP::UserAgent;

our $VERSION = '0.003';
$VERSION = eval $VERSION;

sub build_uri { 
    my($self)=@_;
    return URI->new($self->baseUrl); 
}

has 'apiKey' => (is=>'ro', isa=>Str, required=>1);
has 'ownerCode' => (is=>'ro', isa=>Str, required=>1);
has 'baseUrl' => (is=>'ro', isa=>Str, required=>1);
has 'baseUri' => (is=>'ro', isa=>Uri, lazy=>1, builder=>'build_uri');
has 'sessionId' => (is=>'rw', isa=>Str);
has 'name' => (is=>'rw', isa=>Str, required=>1);

my $ua = LWP::UserAgent->new('Perl Conductrics::Agent');
$ua->timeout(2);
$ua->env_proxy;
my $json = JSON::Any->new;

sub _request {
    my ($self, $uri, @params) = @_;
    my ($seconds, $microseconds) = Time::HiRes::gettimeofday;
    my %parameters = (nocache=>"$seconds$microseconds", apikey=>$self->apiKey, session=>$self->sessionId, @params);
    for my $k (keys %parameters) {
	$uri->query_param_append($k, $parameters{$k});
    }

    say $uri;

    my $response = $ua->get($uri);
    if ($response->is_success) {
	if ($response->code != 200) {
	    say "Content: ", $response->decoded_content;  # or whatever
	    say "Code: ", $response->code;
	    say "Err:", $response->message;
	    warn("Something get wrong on response");
	}

	$json->decode($response->decoded_content);
    } else {
	say "Content: ", $response->decoded_content;  # or whatever
	say "Code: ", $response->code;
	say "Err:", $response->message;
	die $response->status_line;
    }
}

sub decide {
    my ($self, $session, @choices) = @_;
    my $num_of_choices = scalar @choices;
    my $uri = $self->baseUri->clone;
    $uri->path_segments($self->ownerCode, $self->name, "decision", $num_of_choices);
    $self->sessionId($session);
    my $answer;
    eval {
	$answer = $self->_request(
	    $uri,
	    );
    };
    if ($@) {
	die("Not able to get decision");
    }
    return $choices[$answer->{decision}];
}

sub reward {
    my ($self, $session, $goalCode, $value) = @_;
    $value = 1 unless (defined $value);
    my $uri = $self->baseUri->clone;
    $uri->path_segments($self->ownerCode, $self->name, 'goal', $goalCode);
    $self->sessionId($session);
    my $answer;
    eval {
	$answer = $self->_request(
	    $uri,
	    reward=>$value,
	    );
    };
    if ($@) {
	die("Not able to set reward");
    }
    return $answer;
}

sub expire {
    my ($self, $session) = @_;
    my $uri = $self->baseUri->clone;
    $uri->path_segments($self->ownerCode, $self->name, "expire");
    $self->sessionId($session);
    my $answer;
    eval {
	$answer = $self->_request($uri);
    };
    if ($@) {
	die("Not able to expire");
    }
    return $answer;
}

1;

=encoding utf-8

=head1 NAME

Conductrics Agent

=head1 DESCRIPTION

I've got php agent API from conductrics github (https://github.com/conductrics/conductrics-php) 
and I've rewritten it in Modern Perl.
I've substituted rand() calls with less cpu expensive Time::Hires to unvalidate cache.

I'll use this module for a new Catalyst model.

=head1 SYNOPSIS

    use Conductrics::Agent;

    my $agent = Conductrics::Agent->new(
	name=>'', # your conductrics agent
	apiKey=>'',    # place your apikey here
	ownerCode=>'', # place your ownerCode here
	baseUrl=>'http://api.conductrics.com',
    );

    #
    # $agent will ask for a decision the conductrics server about which colour
    #
    my $choice = $agent->decide($userSessionid, qw/red jellow green blue/);
    say $choice;


=head1 METHODS

=head2 decide($sessionId, @choices)

Conductrics will compute the decision and this returns which $choice.

=head2 reward($sessionId, $goalCode, [$value])

Conductrics will collect the numeric value, about the goalCode.

=head2 expire($sessionId)

You are notifing that this session has been closed.

http://www.conductrics.com/ for more info about their analysis service.

=head2 ToDo

Return promises for handling non blocking request to conductrics server.

=head1 AUTHORS

 Ferruccio Zamuner - nonsolosoft@diff.org

=head1 COPYRIGHT

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.


=cut


