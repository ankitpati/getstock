#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;
use LWP::Simple;

BEGIN {
    use File::Basename;
    push @INC, dirname (__FILE__).'/../methods';
}
use Csvstock;

print "testing Csvstock.pm...\n";

my $request_url;

sub setup {
    $request_url = 'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=';
}

sub test {
    eval {
        csv_stock_prices;
    };
    is $@, "Incorrect usage!\n", "No Arguments";

    is csv_stock_prices ('SYMC'),
        get ($request_url.'SYMC'), "Single Argument";

    is csv_stock_prices ('SYMC', 'GOOG', 'MSFT'),
        get ($request_url.'SYMC,GOOG,MSFT'), "Multiple Arguments";

    is csv_stock_prices ('symc'),
        get ($request_url.'SYMC'), "Single Argument Lower Case";

    is csv_stock_prices ('symc', 'goog', 'msft'),
        get ($request_url.'SYMC,GOOG,MSFT'), "Multiple Arguments Lower Case";

    is csv_stock_prices ('invalid-ticker'),
        get ($request_url.'invalid-ticker'), "Invalid Argument";
}

sub teardown {
    undef $request_url;
}

setup;
test;
teardown;
