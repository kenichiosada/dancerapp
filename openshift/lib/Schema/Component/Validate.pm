package Schema::Component::Validate;

use strict;
use warnings;

use base qw( DBIx::Class );

use Carp qw( croak );
use Data::Dumper;

use Conf::Types -all;

#
# Overwrite DBIC methods
#
sub insert {
  my $self = shift;

  $self->_validate;

  return $self->next::method(@_);
}

sub create {
  my $self = shift;

  $self->_validate;

  return $self->next::method(@_);
}

sub update {
  my $self = shift;

  $self->_validate;

  return $self->next::method(@_);
}

#
# functions
#
sub _validate {
  my $self = shift;

  my %data = $self->get_columns;
  my $col_info = $self->result_source->columns_info;

  &_check_nullable($col_info, \%data);
  &_check_datatype_size($col_info, \%data);
}

#check nullable
sub _check_nullable {
  my $col_info = shift;
  my $data     = shift;

  my ( $key, $col );

  foreach $key ( keys %{$col_info} ) {
    $col = $col_info->{$key};
    if ( defined $col->{is_nullable} && $col->{is_nullable} == 0 ) { 
      if ( !$col->{is_auto_increment} && !defined $col->{default_value} ) { 
        if ( !defined $data->{$key} ) {
           croak "Missing required field: $key";
        }
      }
    }
  }
}                     

#check data_type & size 
 sub _check_datatype_size {
  my $col_info = shift;   
  my $data     = shift;   

  my ( $key, $col, $err );     

  foreach $key ( keys %{$data} ) {                     
    my $col = $col_info->{$key};                       

    #skip if data to check is not avaialble           
    next if ( !defined $col );                         
    next if ( !defined $col->{data_type} || $col->{data_type} =~ /[^a-zA-Z]/ ); 

    if ( $col->{data_type} eq 'varchar' ) {            
      $err = Varchar->validate($data->{$key});        
    } elsif ( $col->{data_type} eq 'text' ) {
      $err = Text->validate($data->{$key});
    } elsif ( $col->{data_type} eq 'timestamp' ) {
      $err = Timestamp->validate($data->{$key});

    } elsif ( $col->{data_type} eq 'integer' ) {
      if ( $col->{extra}->{unsigned} ) {
        $err = Integer_unsigned->validate($data->{$key}); 
      } else {
        $err = Integer->validate($data->{$key});
      }
    } elsif ( $col->{data_type} eq 'bigint' ) {
      if ( $col->{extra}->{unsigned} ) {
        $err = Bigint_unsigned->validate($data->{$key}); 
      } else {
        $err = Bigint->validate($data->{$key});
      }
    } elsif ( $col->{data_type} eq 'tinyint' ) {
      if ( $col->{extra}->{unsigned} ) {
        $err = Tinyint_unsigned->validate($data->{$key}); 
      } else {
        $err = Tinyint->validate($data->{$key});
      }
    }

    if ( !$err ) {
      if ( defined $col->{is_nullable} && $col->{is_nullable} == 0 ) {
        if ( !defined $data->{$key} ) {
          $err = "Cannot use undef for number"; 
        }
        if ( $col->{data_type} =~ /^(varchar|text|timestamp)$/ ) {
          if ( length $data->{$key} < 1 ) {
            $err = "Cannot use empty string";
          } elsif ( $data->{$key} =~ /^\s+$/ ) {
            $err = "Cannot use white space only";
          }
        }
      }
    }

    if ( $err ) {
      croak "$err";
    }
  }                       
}  

1;

