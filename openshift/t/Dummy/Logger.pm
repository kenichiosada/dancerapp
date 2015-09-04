package Dummy::Logger;

use strict;
use warnings;

sub new {
  my $class = shift;
  bless {}, $class;
}

sub debug {
  # Do nothing
}

1;
