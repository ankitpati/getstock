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
        print csv_stock_prices @ARGV;
    }
    elsif ($method eq '-s') {
        print scrape_stock_prices @ARGV;
    }
    else {
        die "Usage:\n\tgetstock.pl -<c|s> <ticker>...\n";
    }
} or die "$@\n";
