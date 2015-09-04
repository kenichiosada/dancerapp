#!/usr/local/evn perl

use strict;
use warnings;

use Test::More;

use Dummy::Service;
use Dancer::Test;

my $response = dancer_response( 'GET', '/' );

response_content_like( ['GET', '/'], qr/test/, 'Expecting "test" as content' );

done_testing;

