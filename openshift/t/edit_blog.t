#!/usr/local/evn perl

use strict;
use warnings;

use Test::More import => ['!pass'];

use Dancer ':script';
use Plugin::Db qw( schema );
use Schema;
use Dummy::Logger;

# Drop existing tables and create new ones for test
schema->deploy({ add_drop_table => 1 });
diag( 'Preparing empty tables for test' );

#
# Start testing
#
use_ok 'Model::EditBlog';
use_ok 'Model::Entry';

# Add user for test entry 
my $user_data = {
  user_name => 'testuser',
  password => 'dummypass',
  created => \'NOW()'
};
my $user = schema->resultset('User')->create($user_data);

# Add post for test 
my $entry = {
  user_id => $user->user_id,
  title => 'test title',
  content => 'test content',
  created => \'NOW()'
};
my $post = schema->resultset('Blog')->create($entry);

my $logger = Dummy::Logger->new;
my $EditBlogObj = Model::EditBlog->new({ schema => schema, logger => $logger });

#
# Testing update
#

# Entry object for update
my $updated_entry = {
  blog_id => $post->blog_id,
  user_id => $user->user_id,
  title => 'new title',
  content => 'new content',
  status => 2,
};
my $EntryObj = Model::Entry->new($updated_entry);

my $result = $EditBlogObj->update($EntryObj);

is ( $result, 1, 'Expecting 1 for successful update' );

$post = schema->resultset('Blog')->find(1);

is ( $post->title, $updated_entry->{title}, 'Expecting updated title' );
is ( $post->content, $updated_entry->{content}, 'Expecting updated content' );
is ( $post->status, $updated_entry->{status}, 'Expecting updated status' );

#
# Testing delete
#

$result = $EditBlogObj->delete($post->blog_id);

is ( $result, 1, 'Expecting 1 for successful delete' );

$post = schema->resultset('Blog')->find(1);

ok ( !$post, 'Expecting to find no result' );

done_testing();
