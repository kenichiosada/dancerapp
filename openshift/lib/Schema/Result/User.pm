use utf8;
package Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 status

  data_type: 'smallint'
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
  "user_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "status",
  {
    data_type => "smallint",
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

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 RELATIONS

=head2 blogs

Type: has_many

Related object: L<Schema::Result::Blog>

=cut

__PACKAGE__->has_many(
  "blogs",
  "Schema::Result::Blog",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-30 15:56:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JdA2krnyfnqfMihOif0kzw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
