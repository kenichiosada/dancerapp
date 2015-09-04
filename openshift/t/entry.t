#!/usr/local/evn perl

use strict;
use warnings;

use Test::More;

use_ok( 'Model::Entry' );

my $EntryObj = Model::Entry->new;

$EntryObj->set_inactive;
is ( $EntryObj->status, 0, 'Expecting status 0' );

$EntryObj->set_active;
is ( $EntryObj->status, 1, 'Expecting status 1' );

done_testing();
