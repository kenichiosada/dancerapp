package DancerApp::Post;

use Dancer ':syntax';

use Plugin::Template;
use Plugin::Util qw( getLogger sanitize );
use Plugin::Db qw( schema );

use Schema;
use Model::GetBlog;
use Model::EditBlog;
use Model::Entry;

prefix '/post';

any ['get', 'post'] => '/*' => sub {
  my $page = vars->{page};

  # Get blog post
  my $GetBlogObj = Model::GetBlog->new( 
    logger => getLogger,
    schema => schema,
  );
  my $blog_id = sanitize($page->{section}, 'number');
  my $post = $GetBlogObj->get_post($blog_id);

  # Process update
  if ( $post && request->is_post) {

    my $user_id = $page->{user}->{user_id};
    my $command = sanitize(params->{command}, 'text');

    # command: update or delete
    if ( $user_id && $command ) {

      my $EntryObj = Model::Entry->new(
        user_id => $user_id,
        blog_id => $post->blog_id,
        title   => $post->title,
        content => $post->content,
        status  => $post->status,
      );

      my $EditBlogObj = Model::EditBlog->new(
        logger => getLogger,
        schema => schema,
      );

      if ( $command eq 'update' ) {

        my $title = sanitize(params->{title}, 'text');
        $EntryObj->title($title) if $title;

        my $content = sanitize(params->{content}, 'text'); 
        $EntryObj->content($content) if $content;

        my $status = sanitize(params->{status}, 'number');
        if ( defined $status ) {
          if ( $status == 0 ) {
            $EntryObj->set_inactive;
          } elsif ( $status == 1 ) {
            $EntryObj->set_active;
          } 
        }

        $EditBlogObj->update($EntryObj);
        redirect '/post/' . $EntryObj->blog_id;

      } elsif ( $command eq 'delete' ) {

        $EditBlogObj->delete($EntryObj->blog_id);
        redirect '/blog';

      }
    }
  }

  $page->{post} = $post;

  goTemplate;
};

1;

__END__

=head1 NAME

DancerApp::Post

=head1 DESCRIPTION

Route handler for /post

=cut
