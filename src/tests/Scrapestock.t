#!/usr/bin/env perl

use strict;
use warnings;

my $lwp_simple;
my $test_url;

BEGIN {
    use Test::MockModule;

    my $request_url = qr/http:\/\/finance\.yahoo\.com\/quote\//;
    my $response_span = '<span class="Fw(b) Fz(36px) Mb(-4px)" data-reactid="000">';

    local *lwp_simple_get = sub ($) {
        if ($_[0] =~ /$request_url/) {
            my $ticker = $_[0] =~ s/$request_url//r;

            if ($ticker eq 'DONT') {
                return undef;
            }

            my $ascii_sum;
            $ascii_sum += ord foreach (split //, $ticker);

            $response_span.$ascii_sum.'</span>';
        }
        else {
            my $tickers = $_[0] =~ s/http:\/\/download\.finance\.yahoo\.com\/d\/quotes.csv\?f=l1&s=//r;
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
        }
    };

    $lwp_simple = Test::MockModule->new('LWP::Simple');
    $lwp_simple->mock(get => \&lwp_simple_get);
}

use Test::More tests => 7;
use LWP::Simple;

BEGIN {
    use File::Basename;
    push @INC, dirname (__FILE__).'/../methods';
}
use Scrapestock;

print "testing Scrapestock.pm...\n";

sub setup {
    $test_url = 'http://download.finance.yahoo.com/d/quotes.csv?f=l1&s=';
}

sub test {
    eval {
        new Scrapestock;
    };
    is $@, "Incorrect usage!\n", "No Arguments";

    my $scrape_instance = new Scrapestock('http://finance.yahoo.com/quote/',
        '<span class="Fw\(b\) Fz\(36px\) Mb\(-4px\)" data-reactid="(?:\d+)">(.*?)<\/span>');

    is $scrape_instance->scrape_stock_prices ('SYMC'),
        get ($test_url.'SYMC'), "Single Argument";

    is $scrape_instance->scrape_stock_prices ('SYMC', 'GOOG', 'MSFT'),
        get ($test_url.'SYMC,GOOG,MSFT'), "Multiple Arguments";

    is $scrape_instance->scrape_stock_prices ('symc'),
        get ($test_url.'SYMC'), "Single Argument Lower Case";

    is $scrape_instance->scrape_stock_prices ('symc', 'goog', 'msft'),
        get ($test_url.'SYMC,GOOG,MSFT'), "Multiple Arguments Lower Case";

    is $scrape_instance->scrape_stock_prices ('invalid-ticker'),
        get ($test_url.'invalid-ticker'), "Invalid Argument";

    eval {
        $scrape_instance->scrape_stock_prices ('DONT');
    };
    is $@, "Could not contact servers.\n", "Connection Error";
}

sub teardown {
    undef $lwp_simple;
    undef $test_url;
}

setup;
test;
teardown;
