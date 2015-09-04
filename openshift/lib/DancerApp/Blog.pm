package DancerApp::Blog;

use Dancer ':syntax';

use Plugin::Template;
use Plugin::Util qw( getLogger sanitize );
use Plugin::Db qw( schema );

use Schema;
use Model::GetBlog;
use Model::PostBlog;
use Model::Entry;

prefix '/blog';

any ['get', 'post'] => '/' => sub {
  my $page = vars->{page};
  my $user_id = $page->{user}->{user_id};
  my $title = sanitize(params->{title}, 'text');
  my $content = sanitize(params->{content}, 'text'); 

  my $BlogObj = Model::GetBlog->new( 
    logger => getLogger,
    schema => schema,
  );

  if ( $user_id ) {
    $page->{blog} = $BlogObj->get_all_by_user($user_id);
  } else {
    $page->{blog} = $BlogObj->get_all_active;
  }

  if ( request->is_post ) {
    my $PostBlogObj = Model::PostBlog->new(
      logger => getLogger,
      schema => schema,
    );
    my $EntryObj = Model::Entry->new(
      logger  => getLogger,
      schema  => schema,
      user_id => $user_id,
      title   => $title,
      content => $content,
    );
    $PostBlogObj->post_new($EntryObj);

    redirect '/blog';
  }

  goTemplate;
};

1;

__END__

=head1 NAME

DancerApp::Blog

=head1 DESCRIPTION

Route handler for /blog

=cut
