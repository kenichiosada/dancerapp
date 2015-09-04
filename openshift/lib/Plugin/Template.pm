package Plugin::Template;

use strict;
use warnings;

use Dancer;
use Dancer::Plugin;

use Data::Dumper;

register 'goTemplate' => sub {
  my $page = vars->{page};
  my $template_name;
  if ( defined $page->{location} && $page->{location} ne 'default' ) {
    $template_name = $page->{location} . '.html';
  } else {
    $template_name = 'main.html';
  }

  Dancer::template $template_name, { page => $page };
};

register_plugin;

1;
