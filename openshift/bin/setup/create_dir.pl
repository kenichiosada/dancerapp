#!/usr/bin/env perl

#
# Usage: sh run_script.sh create_dir.pl 
#

use strict;
use warnings;
use File::Path qw( make_path );

use Conf::Settings qw( $CONFIG $TX_CONFIG );

eval {
  make_path ($CONFIG->{SESSION}->{PATH}, $TX_CONFIG->{cache_dir}, {
    verbose => 1,
    mode => 0711,
  }) or warn $!;
}
