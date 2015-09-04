package Conf::Types;

use strict;
use warnings;

use base "Type::Library";
use Type::Utils;
use Types::Standard qw( :all );

# Numbers 

declare "Integer", 
  as Maybe[Int], 
  where { $_ >= -2147483648 && $_ <= 2147483647 };

declare "Integer_unsigned", 
  as Maybe[Int], 
  where { $_ >= 0 && $_ <= 4294967295 };

declare "Bigint", 
  as Maybe[Int], 
  where { $_ >= -9223372036854775808 && $_ <= 9223372036854775808 };

declare "Bigint_unsigned", 
  as Maybe[Int], 
  where { $_ >= 0 && $_ <= 18446744073709551615 };

declare "Tinyint", 
  as Maybe[Int], 
  where { $_ >= -128 && $_ <= 127 };

declare "Tinyint_unsigned", 
  as Maybe[Int], 
  where { $_ >= 0 && $_ <= 255 };

# Strings

declare "Varchar", 
  as Maybe[Str],
  where { length $_ < 65535 };

declare "Text", 
  as Maybe[Str];

# Date Time

declare "Timestamp", 
  where { ref $_ eq 'SCALAR' || ref $_ eq 'REF' || $_ =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/ };

1;
