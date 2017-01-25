#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;

sub scrape_stock_prices {
    my $request_url = 'http://finance.yahoo.com/quote/';
    my $stock_prices;

    foreach (@_) {
        my $webpage = get $request_url.uc or die "Could not contact servers.\n";
        my ($price) = ($webpage =~ /<span class="Fw\(b\) Fz\(36px\) Mb\(-4px\)" data-reactid="(?:\d+)">(.*?)<\/span>/);
        $stock_prices .= $price ? "$price\n" : "N/A\n";
    }

    return $stock_prices;
}

1;
