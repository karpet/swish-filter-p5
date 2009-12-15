use strict;
use warnings;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 2 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

#use Devel::LeakGuard::Object qw( GLOBAL_bless :at_end leakguard );

use_ok('SWISH::Filter');

leaks_cmp_ok {
    my $filter = SWISH::Filter->new;
}
'<', 1;
