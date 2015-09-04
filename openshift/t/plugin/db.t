#!/usr/local/evn perl

use strict;
use warnings;

use Test::More import => ['!pass'];

use Dancer ':script';
use Plugin::Db qw( schema );

use Plack::Test;
$Plack::Test::Impl = 'Server';
use Plack::Util;

use DateTime;
use Data::Dumper;

my $app = Plack::Util::load_psgi("$ENV{'APP_HOME'}/openshift/bin/app.pl");

test_psgi $app, sub {

  schema->deploy({ add_drop_table => 1 });

  my $user = schema->resultset('User')->create({ user_name => 'test', password => 'test', created => \"NOW()" });

  is ( $user->user_id, 1, 'Expecting user_id = 1');

  my $user_name = schema->resultset('User')->find(1)->user_name;

  is ( $user_name, 'test', 'Expecting user_name = "test"' );

};

done_testing();
