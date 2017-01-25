#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;

BEGIN {
    use File::Basename;
    push @INC, dirname (__FILE__).'/methods';
}
use Csvstock;
use Scrapestock;

die "Usage:\n\tgetstock.pl -<c|s> <ticker>...\n" if (@ARGV <= 1);

my $method = shift @ARGV;

eval {
    if ($method eq '-c') {
        my $stock_prices = new Csvstock(
            'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=',
            @ARGV)->csv_stock_prices();
        print $stock_prices;
    }
    elsif ($method eq '-s') {
        my $stock_prices = new Scrapestock('http://finance.yahoo.com/quote/',
            '<span class="Fw\(b\) Fz\(36px\) Mb\(-4px\)" data-reactid="(?:\d+)">(.*?)<\/span>',
            @ARGV)->scrape_stock_prices();
        print $stock_prices;
    }
    else {
        die "Usage:\n\tgetstock.pl -<c|s> <ticker>...\n";
    }
} or die "$@\n";
