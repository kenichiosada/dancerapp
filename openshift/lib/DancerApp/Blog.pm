package DancerApp::Blog;

use Dancer ':syntax';

use Plugin::Template;
use Plugin::Util qw( getLogger sanitize decode_html );
use Plugin::Db qw( schema );

use Schema;
use Model::GetBlog;
use Model::PostBlog;
use Model::Entry;
use Text::Xslate qw( mark_raw );
use HTML::Entities;

prefix '/blog';

any ['get', 'post'] => '/' => sub {
  my $page = vars->{page};
  my $user_id = $page->{user}->{user_id};
  my $title = sanitize(params->{title}, 'text');
  my $content = sanitize(params->{content}, 'html'); 

  my $BlogObj = Model::GetBlog->new( 
    logger => getLogger,
    schema => schema,
  );

  my $blog;
  if ( $user_id ) {
    $blog = $BlogObj->get_all_by_user($user_id);
  } else {
    $blog = $BlogObj->get_all_active;
  }

  if ( request->is_post ) {
    my $PostBlogObj = Model::PostBlog->new(
      logger => getLogger,
      schema => schema,
    );
    my $EntryObj = Model::Entry->new(
      user_id => $user_id,
      title   => $title,
      content => $content,
    );
    $PostBlogObj->post_new($EntryObj);

    redirect '/blog';
  }

  # marinate data for template
  $page->{blog} = [];
  foreach ( @{$blog} ) {
    my %data = $_->get_columns;  
    $data{'content'} = decode_html($data{'content'});
    push @{$page->{blog}}, \%data; 
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
