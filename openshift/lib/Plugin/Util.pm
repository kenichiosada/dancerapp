package Plugin::Util;

use strict;
use warnings;

use Dancer;
use Dancer::Plugin;
use Dancer::Logger::File;

use CGI;
use CGI::Cookie;
use HTML::Scrubber;
use HTML::Entities;
use Text::Xslate qw( mark_raw );

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
      my $scrubber = HTML::Scrubber->new( allow => [ qw/ a p b i pre br ul li / ] );
      $val = $scrubber->scrub($val);
      $val = encode_entities($val);
    }
  }

  return $val;
};

# Need mark_raw for Text::Xslate
register decode_html => sub {
  my $val = shift;
  return mark_raw(decode_entities($val));
};

register_plugin;

1;


