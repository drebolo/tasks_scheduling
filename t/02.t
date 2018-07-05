#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Exception;
use Test::Output;

use Jobs;

subtest 'sequence consisting of a single job a' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>';
    my $j         = Jobs->new();
    my $res       = $j->process($jobs_list);
    is( $res, 'a', 'got a' );
};

subtest 'sequence containing all three jobs abc in no significant order' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>,b=>,c=>';
    my $j         = Jobs->new();
    my $res       = $j->process($jobs_list);
    is( $res, 'c,b,a', 'got c,b,a' );
};

subtest 'sequence that positions c before b, containing all three jobs abc' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>,b=>c,c=>';
    my $j         = Jobs->new();
    my $res       = $j->process($jobs_list);
    is( $res, 'c,b,a', 'got c,b,a' );
};

subtest 'sequence that positions f before c, c before b, b before e and a before d containing all six jobs abcdef' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>,b=>c,c=>f,d=>a,e=>b,f=>';
    my $j         = Jobs->new();
    my $res       = $j->process($jobs_list);
    is( $res, 'f,c,b,e,a,d', 'got f,c,b,e,a,d' );
};

subtest 'error stating that jobs can’t depend on themselves' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>,b=>,c=>c';
    my $j         = Jobs->new();
    throws_ok { $j->process($jobs_list) }
    qr/Error: jobs can't depend on themselves./,
      "Error: jobs can't depend on themselves.";
};

subtest 'error stating that jobs can’t depend on themselves' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>,b=>,c=>c';
    my $j         = Jobs->new();
    throws_ok { $j->process($jobs_list) }
    qr/Error: jobs can't depend on themselves./,
      "Error: jobs can't depend on themselves.";
};

subtest 'error stating that jobs can’t have circular dependencies' => sub {
    plan tests => 1;
    my $jobs_list = 'a=>,b=>c,c=>f,d=>a,e=>,f=>b';
    my $j         = Jobs->new();
    throws_ok { $j->process($jobs_list) }
    qr/Error: jobs can't have circular dependencies./,
      "Error: jobs can't have circular dependenvies.";
};

subtest 'sequence consisting of a single job a (no arrow)' => sub {
    plan tests => 1;
    my $jobs_list = 'a';
    my $j         = Jobs->new();
    my $res       = $j->process($jobs_list);
    stdout_is { $j->print_result } "jobs ordered list is: a\n",
      'print result is a';
};

subtest 'no jobs provided' => sub {
    plan tests => 1;
    my $jobs_list = '';
    my $j         = Jobs->new();
    my $res       = $j->process($jobs_list);
    stdout_is { $j->print_result } "no jobs provided\n", 'no jobs provided';
};

done_testing();
