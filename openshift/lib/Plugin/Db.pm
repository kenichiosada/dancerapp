package Plugin::Db;

use strict;
use warnings;

use Dancer;
use Dancer::Plugin;

use DBIx::Class;

use Conf::Settings qw( $DB_CONFIG );

use Data::Dumper;

register schema => sub {
  my ( $self, $arg ) = plugin_args(@_);

  my $schema_name = defined $arg ? $arg : 'default';

  if ( defined $_[0] && $_[0] =~ /^[a-zA-Z0-9]+$/ ) {
    $schema_name = $_[0];
  }  

  my $conf;
  if ( defined $DB_CONFIG->{$schema_name} ) {
    $conf = $DB_CONFIG->{$schema_name};
  } else {
    $conf = $DB_CONFIG->{default};
  }
  return $conf->{SCHEMA_CLASS}->connect($conf->{DSN}, $conf->{USER}, $conf->{PSW}, $conf->{DBI_PARAMS}); 
};

register_plugin;

1;


