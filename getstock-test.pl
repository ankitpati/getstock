#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;

system $_ foreach (glob dirname (__FILE__).'/src/tests/*.t');
