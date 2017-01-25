#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;

sub get_stock_prices {
    my $request_url = 'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=';
    $request_url .= uc "$_," foreach (@_);

    my $stock_prices = get $request_url or die "Could not contact servers.\n";

    return $stock_prices;
}

1;
