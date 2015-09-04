package Model::EditBlog;

use Moo;
extends 'Model';

use Try::Tiny;

sub update {
  my $self  = shift;
  my $entry = shift;

  my $result = 0;

  my $blog_rs = $self->rs('Blog'); 

  if ( $blog_rs->search({ blog_id => $entry->blog_id })->count ) {
    try {
      $blog_rs->update_post($entry);
      $result = 1;
    } catch {
      $self->logger->debug("Updating blog failed: $_");
      $result = 0;
    }
  }

  return $result;
}

sub delete {
  my $self  = shift;
  my $blog_id = shift;

  my $result = 0;

  my $blog_rs = $self->rs('Blog');

  if ( $blog_rs->search({ blog_id => $blog_id })->count ) {
    try {
      $blog_rs->find($blog_id)->delete;
      $result = 1;
    } catch {
      $self->logger->debug("Updating blog failed: $_");
      $result = 0;
    }
  }

  return $result;
}

1;
