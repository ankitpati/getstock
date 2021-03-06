#!/usr/bin/env perl

use strict;
use warnings;

my $lwp_simple;

my $test_url;

BEGIN {
    use Test::MockModule;

    $test_url = 'fake://example.org/endpoint?';

    local *lwp_simple_get = sub ($) {
        my $tickers = $_[0] =~ s/\Q$test_url\E//r;
        my @tickers = split /,/, $tickers;

        my $stock_prices;

        foreach (@tickers) {
            if ($_ eq 'DONT') {
                return undef;
            }

            elsif (/^(?:[A-Z]{2,4}:(?![A-Z\d]+\.))?(?:[A-Z]{1,4}|\d{1,3}(?=\.)|\d{4,})(?:\.[A-Z]{2})?$/) {
                my $ascii_sum;
                $ascii_sum += ord foreach (split //);
                $stock_prices .= "$ascii_sum\n";
            }

            else {
                $stock_prices .= "N/A\n";
            }
        }

        $stock_prices ? $stock_prices : "\n";
    };

    $lwp_simple = Test::MockModule->new('LWP::Simple');
    $lwp_simple->mock(get => \&lwp_simple_get);
}

use Test::More tests => 8;
use LWP::Simple;

BEGIN {
    use File::Basename;
    push @INC, dirname (__FILE__).'/../methods';
}
use Csvstock;

print "testing Csvstock.pm...\n";

sub test {
    eval {
        new Csvstock;
    };
    is $@, "Incorrect usage!\n", "No Arguments";

    my $csv_instance = new Csvstock($test_url);

    is $csv_instance->{request_url}, $test_url, "Test URL";

    is $csv_instance->csv_stock_prices ('SYMC'),
        get ($test_url.'SYMC'), "Single Argument";

    is $csv_instance->csv_stock_prices ('SYMC', 'GOOG', 'MSFT'),
        get ($test_url.'SYMC,GOOG,MSFT'), "Multiple Arguments";

    is $csv_instance->csv_stock_prices ('symc'),
        get ($test_url.'SYMC'), "Single Argument Lower Case";

    is $csv_instance->csv_stock_prices ('symc', 'goog', 'msft'),
        get ($test_url.'SYMC,GOOG,MSFT'), "Multiple Arguments Lower Case";

    is $csv_instance->csv_stock_prices ('invalid-ticker'),
        get ($test_url.'invalid-ticker'), "Invalid Argument";

    eval {
        $csv_instance->csv_stock_prices ('DONT');
    };
    is $@, "Could not contact servers.\n", "Connection Error";
}

sub teardown {
    undef $lwp_simple;
    undef $test_url;
}

test;
teardown;
