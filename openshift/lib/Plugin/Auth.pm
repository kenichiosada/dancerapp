package Plugin::Auth;

use strict;
use warnings;

use Data::Dumper;

use Dancer;
use Dancer::Plugin;
use Plugin::Db qw( schema );
use Crypt::PBKDF2;
use Try::Tiny;

my $settings = {};

register auth => sub {
  $settings = plugin_setting;
  return Plugin::Auth->new(@_);
};

register authd => sub {
  if ( session('user') ) {
    if ( session('user')->{user_id} ) {
      return true;
    }
  }
  return false;
};

sub new {
  my $class  = shift;
  my @credentials = @_;

  my $self   = {};
  bless $self, $class;

  my $user = session 'user';

  if ( $user ) {
    session->destroy;
    $user = session 'user';
  } 

  $user = {
    user_id   => undef,
    user_name => undef,
    error     => [],
  };

  session 'user' => $user;
  $self->_authenticate(\@credentials);

  return $self;
}

sub errors {
  my ( $self, @errors ) = @_; 
  my $user = session('user');
  push @{$user->{error}}, @errors;
  session 'user' => $user;
  return @{ session('user')->{error} };
}

sub _authenticate {
  my $self   = shift;
  my $credentials = shift;

  my $username = @{$credentials}[0];
  my $password = @{$credentials}[1];

  if ( $username ) { 
    unless ( $password ) {
      $self->errors('MISSING PASSWORD WHILE AUTHENTICATE');
      return 0;
    }

    my $pbkdf2 = Crypt::PBKDF2->new(
      hash_class => $settings->{hash_class},
      hash_args  => {
        sha_size => $settings->{sha_size},
      },
      iterations => $settings->{iterations},
      salt_len   => $settings->{salt_len},
    );

    my $user = schema->resultset('User')->find({ user_name => $username });

    if ( $user ) {
      if ( defined $user->status && $user->status != 1 ) {
        $self->errors(['USER_NAME NOT ACTIVE', $user]);
        return 0;
      } else {
        unless ( defined $user->password ) {
          $self->errors(['USER_NAME IS MISSING PASSWORD', $user]);
          return 0;
        }
        my $hash = $user->password;
        my $result;
        try {
          $result = { pass => $pbkdf2->validate($hash, $password) };
          $result->{error} = 'PASSWORD INCORRECT' if $result->{pass} == 0;
        } catch {
          $result = { pass => 0, error => 'HASH IS INVALID FORMAT' };
        };
        if ( $result->{pass} == 1 ) {
          session 'user' => {
            user_id => $user->user_id,
            user_name => $user->user_name,
          };
          return 1;
        } else {
          $self->errors($result->{error});
          return 0;
        }
      }
    } else {
      $self->errors(['USER_NAME NOT FOUND', $username]);
      return 0;
    }
  } else {  
    $self->errors('MISSING USER_NAME WHILE AUTHENTICATE');
  }
}

register_plugin;

1;
