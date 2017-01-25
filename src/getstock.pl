#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;

die "Usage:\n\tgetstock.pl -s <ticker>...\n"
                                        if (@ARGV <= 1 || shift @ARGV ne '-s');

my $request_url = 'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=';
$request_url .= uc "$_," foreach (@ARGV);

print get($request_url);
