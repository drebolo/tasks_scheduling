#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long::Descriptive;
use Jobs;

my ($opt, $usage) = describe_options(
    '%c %o',
    ['jobs|j=s' => 'a string of comma separated values of jobs and its depencies e.g.: "a=>f,b,c,d" ', { required => 1 }],
    ['help'     => 'Print usage and exit', {shortcircuit => 1}]
);

print($usage->text) and exit if $opt->help;


my $j = Jobs->new( );
$j->process($opt->jobs);
$j->print_result;
