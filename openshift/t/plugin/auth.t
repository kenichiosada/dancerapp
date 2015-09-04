#!/usr/local/evn perl

use strict;
use warnings;

use Test::More import => ['!pass'];

use Dancer ':script';
use Plugin::Db qw( schema );
use Plugin::Auth;

use Plack::Test;
$Plack::Test::Impl = 'Server';
use Plack::Util;

use DateTime;
use Data::Dumper;

my $app = Plack::Util::load_psgi("$ENV{'APP_HOME'}/openshift/bin/app.pl");

test_psgi $app, sub {

  # Drop existing tables and create new ones for test
  schema->deploy({ add_drop_table => 1 });
  diag( 'Preparing empty tables for test' );

  my ( $pbkdf2, $hashed_password );

  # Create Crypt::PBKDF object
  my $settings = config->{plugins}->{'Plugin::Auth'};
  $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => $settings->{hash_class},
    sha_args   => {
      sha_size => $settings->{sha_size}, 
    },
    iterations => $settings->{iterations},
    salt_len   => $settings->{salt_len},
  );

  # Set up test user account
  my $test_user = {
    user_name => 'testuser',
    password  => 'test123',
  };
  $hashed_password = $pbkdf2->generate($test_user->{password});
  my $newuser = schema->resultset('User')->create({
    user_name => $test_user->{user_name},
    password  => $hashed_password,
    created   => \'NOW()',
  });
  diag "Test user 1 is created.";

  # Set up another test account
  my $test_user2 = {
    user_name => 'testuser2',
    password  => 'test123',
  };
  $hashed_password = $pbkdf2->generate($test_user->{password});
  my $newuser2 = schema->resultset('User')->create({
    user_name => $test_user2->{user_name},
    password  => $hashed_password,
    created   => \'NOW()',
  });
  diag "Test user 2 is created.";

  session foo => 'bar';
  my $foo = session 'foo';
  is ( $foo, 'bar', "Check session working" );


  my ( $user, $user2, $userdata );

  # Start testing
  is ( authd, 0, 'Checking session before user login. Expect false.' ); 

  $user = auth;
  is ( $user->authd, 0, 'Authentication without login data. Expect 0 for authd.' ); 
  is ( $user->errors, 1, 'Expecting error' );
  diag Dumper $user->errors;

  $user = auth($test_user->{user_name}, '');
  is ( $user->authd, 0, 'Authentication without password. Expect 0 for authd.' ); 
  is ( $user->errors, 1, 'Expecting error' );
  diag Dumper $user->errors;

  $user = auth('', $test_user->{password});
  is ( $user->authd, 0, 'Authentication without login data. Expect 0 for authd.' ); 
  is ( $user->errors, 1, 'Expecting error' );
  diag Dumper $user->errors;

  $user = auth($test_user->{user_name}, $test_user->{password});
  $userdata = session 'user';
  is ( $user->errors, 0, 'Expecting no error' );
  is ( authd, 1, 'Checking login. Expect true.' );
  cmp_ok ($userdata->{user_id}, '==', $newuser->user_id, 'User logged in. Expecting same user_id.' );

  $user2 = auth($test_user2->{user_name}, $test_user2->{password}); 
  $userdata = session 'user';
  is ( $user->errors, 0, 'Expecting no error' );
  is ( authd, 1, 'Checking login. Expect true.' );
  cmp_ok ($userdata->{user_id}, '==', $newuser2->user_id, 'User logged in. Expecting same user_id.' );
};

done_testing();
