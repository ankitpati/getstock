#!/usr/bin/env perl

use strict;
use warnings;

package Csvstock;

use LWP::Simple;

sub new {
    die "Incorrect usage!\n" if (@_ != 2);

    my $class = shift;
    my $self = {
        request_url => $_[0]
    };

    return bless $self;
}

sub csv_stock_prices {
    die "Incorrect usage!\n" if (@_ < 2);

    my $self = shift;
    my @tickers = @_;

    my $request_url = $self->{request_url};
    $request_url .= uc "$_," foreach (@tickers);

    my $stock_prices = get $request_url or die "Could not contact servers.\n";

    return $stock_prices;
}

1;
