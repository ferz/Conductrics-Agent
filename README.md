# Conductrics-Agent

## DESCRIPTION

    I've got php agent API from conductrics github
    (https://github.com/conductrics/conductrics-php) and I've rewritten it in
    Modern Perl. I've substituted rand() calls with less cpu expensive
    Time::Hires to unvalidate cache.

    I'll use this module for a new Catalyst model.

## SYNOPSIS

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

## METHODS

   - decide($sessionId, @choices)
     Conductrics will compute the decision and this returns which $choice.

   - reward($sessionId, $goalCode, [$value])
     Conductrics will collect the numeric value, about the goalCode.

   - expire($sessionId)
     You are notifing that this session has been closed.

    http://www.conductrics.com/ for more info about their analysis service.

## ToDo
    Return promises for handling non blocking request to conductrics server.

## AUTHORS

     Ferruccio Zamuner - nonsolosoft@diff.org

## COPYRIGHT

    This library is free software. You can redistribute it and/or modify it
    under the same terms as Perl itself.
