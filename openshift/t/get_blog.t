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
use_ok 'Model::GetBlog';

my $logger = Dummy::Logger->new;
my $GetBlogObj = Model::GetBlog->new({ schema => schema, logger => $logger });

#
# get_all_active
#

# Test empty result
my $blog = $GetBlogObj->get_all_active;
ok ( ( ref $blog eq 'ARRAY' && scalar @{$blog} < 1 ), 'Expecting empty array' );

# Add test user 
my $user_data = {
  user_name => 'testuser',
  password => 'dummypass',
  created => \'NOW()'
};
my $user = schema->resultset('User')->create($user_data);

# Add test entry
my $entry = {
  user_id => $user->user_id,
  title => 'test title',
  content => 'test content',
  created => \'NOW()'
};
my $post = schema->resultset('Blog')->create($entry);

# Check if I can get all entries
$blog = $GetBlogObj->get_all_active;
ok ( ( ref $blog eq 'ARRAY' && scalar @{$blog} == 1 ), 'Expecting 1 result' );
is ( $blog->[0]->title, 'test title', 'Expecting correct title' );

#
# get_post
#
$post = $GetBlogObj->get_post;
ok ( !$post, 'Expecting undef without giving blog_id' ); 

$post = $GetBlogObj->get_post(1);
ok ( %{$post}, 'Expecting to get post data' );

$post = $GetBlogObj->get_post(99);
ok ( !$post, 'Expecting undef with non existing blog_id' ); 

done_testing();
