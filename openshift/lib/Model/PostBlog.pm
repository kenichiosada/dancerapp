package Model::PostBlog;

use Moo;
extends 'Model';

use Try::Tiny;

sub post_new {
  my $self  = shift;
  my $entry = shift;

  my $post = {};

  if ( $entry ) {
    try {
      $post = $self->rs('Blog')->insert($entry);
    } catch {
      $self->logger->debug("Post blog failed: $_");
    }
  }

  return $post;
}

1;
