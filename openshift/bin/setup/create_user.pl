#!/usr/bin/env perl

#
# Usage: sh run_script.sh create_user.pl -o <username> -o <password>
#

use strict;

use Dancer ':script';
use Plugin::Db 'schema';
use Schema;
use Conf::Settings qw( $CONFIG $TX_CONFIG $SESSION );

use Crypt::PBKDF2;
use Data::Dumper;

my ( $user_name, $password ) = @ARGV;

if ( !defined $user_name || !defined $password ) {
  print "Missing user_name or password\n";
  exit;
}

my $settings = config->{plugins}->{'Plugin::Auth'};

# Generate encrypted password 
my $pbkdf2 = Crypt::PBKDF2->new(
  hash_class => $settings->{hash_class},
  sha_args   => {
    sha_size => $settings->{sha_size}, 
  },
  iterations => $settings->{iterations},
  salt_len   => $settings->{salt_len},
);
my $hashed_password = $pbkdf2->generate($password);

my $user_rs = schema->resultset('User');

my $user_exist = $user_rs->search({ 'user_name' => $user_name })->count;

if ( $user_exist ) {
  print "Given user_name already exist\n";
} else {
  $user_rs->create({
    user_name => $user_name,
    password  => $hashed_password,
    created   => \'NOW()',
  });
  print "Done\n";
}
