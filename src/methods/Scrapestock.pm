#!/usr/bin/env perl

use strict;
use warnings;

package Scrapestock;

use LWP::Simple;

sub new {
    die "Incorrect usage!\n" if (@_ < 3);

    my $class = shift;
    my $self = {
        request_url => $_[0],
        pattern => $_[1],
        tickers => [@_]
    };
    shift @{$self->{tickers}};
    shift @{$self->{tickers}};

    return bless $self;
}

sub scrape_stock_prices {
    die "Incorrect usage!\n" if (@_ != 1);

    my $self = shift;

    my $stock_prices;

    foreach (@{$self->{tickers}}) {
        my $webpage =
            get $self->{request_url}.uc or die "Could not contact servers.\n";
        my ($price) = ($webpage =~ $self->{pattern});
        $stock_prices .= $price ? "$price\n" : "N/A\n";
    }

    return $stock_prices;
}

1;
