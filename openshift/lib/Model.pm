package Model;

use Moo;

use Conf::Types qw( :all );

has 'schema' => (
  is => 'rw'
);

has 'logger' => (
  is => 'rw'
);

sub rs {
  my ( $self, $result ) = @_;
  return $self->schema->resultset($result); 
}

1;
