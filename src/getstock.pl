#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;

die "Usage:\n\tgetstock.pl -s <ticker>...\n"
                                        if (@ARGV <= 1 || shift @ARGV ne '-s');

my $request_url = 'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=';
$request_url .= uc "$_," foreach (@ARGV);

my $stock_prices = get($request_url) or die "Could not contact servers.\n";

print $stock_prices;
