package Schema::ResultSet::Blog;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

use Carp qw( croak );

sub insert {
  my ( $self, $entry ) = @_;
  $self->create({
    title   => $entry->title,
    content => $entry->content,
    user_id => $entry->user_id,
    created => \'NOW()',
  });
}

sub update_post {
  my ( $self, $entry ) = @_;

  $self->find($entry->blog_id)->update({
    title   => $entry->title,
    content => $entry->content,
    status  => $entry->status,
  });
}

1;
