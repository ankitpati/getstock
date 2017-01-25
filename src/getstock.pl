#!/usr/bin/env perl

use strict;
use warnings;

use LWP::Simple;
use Getstock;

die "Usage:\n\tgetstock.pl -s <ticker>...\n"
                                        if (@ARGV <= 1 || shift @ARGV ne '-s');

print get_stock_prices @ARGV;
