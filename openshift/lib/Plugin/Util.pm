package Plugin::Util;

use strict;
use warnings;

use Dancer;
use Dancer::Plugin;
use Dancer::Logger::File;

use CGI;
use CGI::Cookie;

# Get cookie
register getCookie => sub {
  my %cookies = CGI::Cookie->fetch;
  if ( !defined $cookies{$_[0]} ) {
    return 0;
  } else {
    return $cookies{$_[0]}->value;
  }
};

# Return logger obj
register getLogger => sub {
  my $logger = Dancer::Logger::File->new;
  return $logger;
};

# Sanitize passed value
# veeeerrrryyyyy basic, need to fix later
register sanitize => sub {
  my ( $val, $type ) = @_;

  if ( defined $val && defined $type ) {
    if ( $type eq 'number' ) {
      $val =~ s/[^0-9]//g;
    }
    if ( $type eq 'text' ) {
      $val =~ s/[~`@#\$%\^&\*\(\)\+=\{\}\[\]\\\|\:\;\'"\<\>\?\/]//g;
    }
    if ( $type eq 'html' ) {

    }
  }

  return $val;
};

register_plugin;

1;


