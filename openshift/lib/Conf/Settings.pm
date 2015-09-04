package Conf::Settings;

BEGIN {
  if ( !$ENV{'OPENSHIFT_APP_NAME'} ) {
    $ENV{'APP_HOME'} = '/var/www/sample/';
    if ( defined $ENV{'DANCER_ENVIRONMENT'} && $ENV{'DANCER_ENVIRONMENT'} eq 'sandbox' ) {
      $ENV{'APP_SETTING'} = 'sandbox';
    } else {
      $ENV{'APP_SETTING'} = 'development';
    }
  } else {
    $ENV{'APP_HOME'} = $ENV{'OPENSHIFT_REPO_DIR'};
    $ENV{'APP_SETTING'} = 'production';
  }
};

use base qw( Exporter );

require "$ENV{'APP_HOME'}openshift/lib/Conf/$ENV{'APP_SETTING'}.conf";

@EXPORT_OK = qw( $DEBUG $CONFIG $DB_CONFIG $TX_CONFIG $SESSION );

1;
