#!/usr/bin/env perl

use strict;
use warnings;

package Scrapestock;

use LWP::Simple;

sub new {
    die "Incorrect usage!\n" if (@_ != 3);

    my $class = shift;
    my $self = {
        request_url => $_[0],
        pattern => $_[1],
    };

    return bless $self;
}

sub scrape_stock_prices {
    die "Incorrect usage!\n" if (@_ < 2);

    my $self = shift;
    my @tickers = @_;

    my $stock_prices;

    foreach (@tickers) {
        my $price;
        $_ = uc;
        if (/^(?:[A-Z]{2,4}:(?![A-Z\d]+\.))?(?:[A-Z]{1,4}|\d{1,3}(?=\.)|\d{4,})(?:\.[A-Z]{2})?$/) {
            my $webpage = get $self->{request_url}.$_
                                        or die "Could not contact servers.\n";
            ($price) = ($webpage =~ $self->{pattern});
        }
        $stock_prices .= $price ? "$price\n" : "N/A\n";
    }

    return $stock_prices;
}

1;
