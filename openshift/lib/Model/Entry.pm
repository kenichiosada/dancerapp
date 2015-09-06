package Model::Entry;

use Moo;

use Conf::Types qw( :all );

has user_id => ( 
  is => 'rw',
  isa => Integer_unsigned
);

has blog_id => (
  is => 'rw',
  isa => Integer_unsigned
);

has title => (
  is => 'rw',
  isa => Varchar
);

has content => (
  is => 'rw',
  isa => Text
);

has status => (
  is => 'rw',
  isa => Tinyint
);

has created => (
  is => 'rw',
  isa => Timestamp
);

has updated => (
  is => 'rw',
  isa => Timestamp
);

sub set_inactive {
  my $self = shift;
  $self->status(0);  
}

sub set_active {
  my $self = shift;
  $self->status(1);
}

1;
