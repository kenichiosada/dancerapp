package Model::GetBlog;

use Moo;
extends 'Model';

sub get_all_active {
  my $self = shift;

  my @result = $self->rs('Blog')->search({ status => 1 })->all;

  return \@result;
}

sub get_all_by_user {
  my $self = shift;
  my $user_id = shift;

  my @result = $self->rs('Blog')->search({ user_id => $user_id })->all;

  return \@result;
}


sub get_post {
  my $self = shift;
  my $blog_id = shift;

  my $result;

  if ( $blog_id ) {
    $result = $self->rs('Blog')->single({ blog_id => $blog_id });
  }

  return $result;
}

1;
