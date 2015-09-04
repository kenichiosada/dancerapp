package Dummy::Service;

use Dancer;
use Plugin::Template;

set 'views' => "$ENV{'APP_HOME'}/t/Dummy/views";

get '/' => sub {
  goTemplate;
};

1;
