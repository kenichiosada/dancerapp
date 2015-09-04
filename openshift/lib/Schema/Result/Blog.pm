use utf8;
package Schema::Result::Blog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Blog

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components( qw/ InflateColumn::DateTime +Schema::Component::Validate / );

=head1 TABLE: C<blog>

=cut

__PACKAGE__->table("blog");

=head1 ACCESSORS

=head2 blog_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 content

  data_type: 'text'
  is_nullable: 1

=head2 status

  data_type: 'tinyint'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "blog_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "content",
  { data_type => "text", is_nullable => 1 },
  "status",
  {
    data_type => "tinyint",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "created",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</blog_id>

=back

=cut

__PACKAGE__->set_primary_key("blog_id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-30 15:56:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:G/b+CVVrXvgBR1WjbZ1mng


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
