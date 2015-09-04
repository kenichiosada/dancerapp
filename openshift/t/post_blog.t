#!/usr/local/evn perl

use strict;
use warnings;

use Test::More import => ['!pass'];

use Dancer ':script';
use Plugin::Db qw( schema );
use Schema;
use Dummy::Logger;

use Data::Dumper;

use_ok 'Model::PostBlog';
use_ok 'Model::Entry';

my $logger = Dummy::Logger->new;

my $PostBlogObj = Model::PostBlog->new({ schema => schema, logger => $logger });

# Drop existing tables and create new ones for test
schema->deploy({ add_drop_table => 1 });
diag( 'Preparing empty tables for test' );

# Add user for test entry 
my $user_data = {
  user_name => 'testuser',
  password => 'dummypass',
  created => \'NOW()'
};
my $user = schema->resultset('User')->create($user_data);

my $entry = {
  user_id => $user->user_id,
  title => 'test title',
  content => 'test content',
  created => \'NOW()'
};

my $EntryObj = Model::Entry->new($entry);

my $post = $PostBlogObj->post_new($EntryObj);

is ( $post->blog_id, 1, 'Expecting correct blog_id for new post' );

done_testing();
