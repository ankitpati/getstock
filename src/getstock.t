#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;
use LWP::Simple;
use Getstock;

print "testing Getstock.pm...\n";

my $request_url;

sub setup {
    $request_url = 'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=';
}

sub test {
    is get_stock_prices ('SYMC'), get ($request_url.'SYMC'), "Single Argument";

    is get_stock_prices ('SYMC', 'GOOG', 'MSFT'),
        get ($request_url.'SYMC,GOOG,MSFT'), "Multiple Arguments";

    is get_stock_prices ('symc'),
        get ($request_url.'SYMC'), "Single Argument Lower Case";

    is get_stock_prices ('symc', 'goog', 'msft'),
        get ($request_url.'SYMC,GOOG,MSFT'), "Multiple Arguments Lower Case";

    is get_stock_prices ('invalid-ticker'),
        get ($request_url.'invalid-ticker'), "Invalid Argument";
}

sub teardown {
    undef $request_url;
}

setup;
test;
teardown;
