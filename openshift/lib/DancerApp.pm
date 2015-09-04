package DancerApp;
our $VERSION = '0.1';

#
# App modules
#
use Dancer ':syntax';

use Plugin::Auth;
use Plugin::Template;
use Plugin::Util;
use Schema; 

use DancerApp::Blog;
use DancerApp::Post;

use Conf::Settings qw( $CONFIG $TX_CONFIG );

use Data::Dumper;

prefix undef;

hook 'before' => sub {
  # Make data available for template
  my $page = {};
  var 'page' => $page;

  # Config for xslate
  $page->{tx_config} = $TX_CONFIG; 

  # Requested path
  &_parse_LSSN($page);

  # Params
  $page->{params} = params;

  # Check if user needs to access via HTTPS 
  &_check_https($page);

  # If user's logged in, make user data available
  &_check_login($page);
};

get '/' => sub {
  goTemplate;
};

any ['get', 'post'] => '/login' => sub {
  # If user is already logged in, take hime to top page.
  if ( authd ) {
    redirect $CONFIG->{HTTPS_HOST};
  } else {
    if ( request->is_post ) {
      my $username = sanitize(params->{'username'}, 'text');
      my $password = sanitize(params->{'password'}, 'text');
      my $auth = auth( $username, $password ); 
    
      if ( !$auth->errors ) {
        my $user = session 'user';
        session->destroy;
        session 'user' => $user; # create new session key after user login
        session 'auth' => { 
          user_agent  => request->{env}->{HTTP_USER_AGENT},
          remote_addr => request->{env}->{REMOTE_ADDR},
          timestamp   => time 
        };
        redirect $CONFIG->{HTTPS_HOST};;
      } else {
        redirect '/login?fail=1';
      }
    } else {
      goTemplate;
    } 
  }
};

get '/logout' => sub {
  session 'user' => {};
  session->destroy;
  goTemplate;
};

any qr{.*} => sub {
  status 'not_found';
  redirect '/404.html'; 
};

# Parse URL and sanitize
sub _parse_LSSN {
  my $page = shift;
  my @uri = split('/', request->{path_info});

  foreach ( @uri ) {
    $_ = sanitize($_, 'text');
  }

  $page->{location}   = $uri[1];
  $page->{section}    = $uri[2];
  $page->{subSection} = $uri[3];
  $page->{navSection} = $uri[4];
  
  if ( !defined $page->{location} ) {
    $page->{location} = 'default';
  }
}

# Check request is secure and redirect if necessary
sub _check_https {
  my $page = shift;
  if ( !request->secure ) {
    if ( exists $CONFIG->{REQ_HTTPS}->{$page->{location}} ) {
      redirect $CONFIG->{HTTPS_HOST} . request->{path_info};
    }
    if ( exists $CONFIG->{REQ_LOGIN}->{$page->{location}} ) {
      redirect $CONFIG->{HTTPS_HOST} . request->{path_info};
    }
  }
}

# Check login
sub _check_login {
  my $page = shift;

  if ( authd ) {
    if ( session('auth') ) {
      if ( session('auth')->{user_agent} eq request->{env}->{HTTP_USER_AGENT} && 
        session('auth')->{remote_addr} eq request->{env}->{REMOTE_ADDR} &&  
        session('auth')->{timestamp} + $CONFIG->{SESSION}->{LIFE} > time ) {
          $page->{user} = session('user');
          $page->{auth} = session('auth');
      } else {
        session->destroy;
      }  
    } else {
      session->destroy;
    }
  } else {
    if ( defined $CONFIG->{REQ_LOGIN}->{$page->{location}} ) {
      redirect $CONFIG->{HTTPS_HOST} . '/login';
    }
  }
}

1;

__END__

=head1 NAME

DancerApp

=head1 DESCRIPTION

Route handler for /. 
It is also a place to define all hooks.

=cut
