#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
    use File::Basename;
    push @INC, dirname (__FILE__).'/methods';
}
use Csvstock;
use Scrapestock;
use Parsestock;

my $usage = "Usage:\n\tgetstock.pl -<c|s|p> <ticker>...";

die "$usage\n" if (@ARGV <= 1);

my $method = shift @ARGV;

eval {
    my $stock_prices;

    if ($method eq '-c') {
        $stock_prices = new Csvstock(
            'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=')
            ->csv_stock_prices (@ARGV);
    }
    elsif ($method eq '-s') {
        $stock_prices = new Scrapestock('https://finance.yahoo.com/quote/',
            qr|<span class=".*? Fw\(b\) Fz\(36px\) Mb\(-4px\) .*?" data-reactid="\d+">([^<]*?)</span>|)
            ->scrape_stock_prices (@ARGV);
    }
    elsif ($method eq '-p') {
        $stock_prices = new Parsestock('https://finance.yahoo.com/quote/')
            ->parse_stock_prices (@ARGV);
    }
    else {
        die "$usage\n";
    }

    print $stock_prices;
} or die "$@\n";
