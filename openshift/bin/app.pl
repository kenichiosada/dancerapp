#!/usr/bin/env perl

use strict;

use Dancer;
use DancerApp;
use Plack::Builder;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;

use Conf::Settings qw( $CONFIG $TX_CONFIG $SESSION );

set engines => { 
  xslate => { 
    cache_dir  => $TX_CONFIG->{cache_dir},
    cache      => 1,
    extension  => 'html',
    module     => [ 'Text::Xslate::Bridge::Star' ],
  } 
};

set public => $CONFIG->{DOC_ROOT};

set log_path => $CONFIG->{LOG_DIR} if defined $CONFIG->{LOG_DIR};

builder {
  enable 'Session',
    state => Plack::Session::State::Cookie->new(
      expires  => $CONFIG->{SESSION}->{LIFE},
      secure   => 1,
      httponly => 1,
    ),
    store => Plack::Session::Store::File->new(
      dir => $CONFIG->{SESSION}->{PATH},
    );
  enable 'Plack::Middleware::Static',
    path => qr{^/(images|js|css|favicon\.ico)/}, root => $CONFIG->{DOC_ROOT};

  dance;
};

