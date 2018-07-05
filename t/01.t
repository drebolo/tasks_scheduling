#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

require_ok('Jobs');
can_ok(
    'Jobs',
    qw/job_list queue process print_result order_list _add_with_dependency
      _add_simple _remove_spaces _split_by_comma _split_by_arrow _find_by_name/
);

require_ok('Job');
can_ok( 'Job',
    qw/name dependents is_visited add_dependent _can_add_dependent/ );

done_testing;
