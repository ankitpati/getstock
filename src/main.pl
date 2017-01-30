#!/usr/bin/env perl

use strict;
use warnings;

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
            'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=')
            ->csv_stock_prices (@ARGV);
        print $stock_prices;
    }
    elsif ($method eq '-s') {
        my $stock_prices = new Scrapestock('https://finance.yahoo.com/quote/',
            '<span class="Fw\(b\) Fz\(36px\) Mb\(-4px\)" data-reactid="(?:\d+)">(.*?)<\/span>')
            ->scrape_stock_prices (@ARGV);
        print $stock_prices;
    }
    else {
        die "Usage:\n\tgetstock.pl -<c|s> <ticker>...\n";
    }
} or die "$@\n";
