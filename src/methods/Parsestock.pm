#!/usr/bin/env perl

use strict;
use warnings;

package Parsestock;

use LWP::Simple;
use HTML::Tree;

sub new {
    die "Incorrect usage!\n" if (@_ != 2);

    my $class = shift;
    my $self = {
        request_url => $_[0]
    };

    bless $self;
}

sub parse_stock_prices {
    die "Incorrect usage!\n" if (@_ < 2);

    my $self = shift;
    my @tickers = @_;

    my $stock_prices;

    foreach (@tickers) {
        my $price;
        $_ = uc;
        if (/^(?:[A-Z]{2,4}:(?![A-Z\d]+\.))?(?:[A-Z]{1,4}|\d{1,3}(?=\.)|\d{4,})(?:\.[A-Z]{2})?$/) {
            my $webpage = get $self->{request_url}.$_
                                        or die "Could not contact servers.\n";

            my $root = new HTML::Tree();
            $root->parse_content ($webpage);
            $root->elementify;

            my $price_span = $root->look_down (
                _tag => 'span',
                class => 'Fw(b) Fz(36px) Mb(-4px)',
                'data-reactid' => qr/\d+/
            );

            ($price) = $price_span ? $price_span->content_list : undef;

            $root->delete;
        }
        $stock_prices .= $price ? "$price\n" : "N/A\n";
    }

    $stock_prices;
}

1;
