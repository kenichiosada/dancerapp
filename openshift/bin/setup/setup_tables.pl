#!/usr/bin/env perl

#
# Usage: sh run_script.sh setup_tables.pl -o new
#

use strict;

use Dancer ':script';
use Plugin::Db 'schema';
use Schema;
use Conf::Settings qw( $CONFIG $TX_CONFIG $SESSION );

if ( $ARGV[0] eq 'new' ) {
  schema->deploy({ add_drop_table => 1 });
  print "Done\n";
} else {
  print "Did nothing\n";
}
