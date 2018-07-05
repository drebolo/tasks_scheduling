requires 'Getopt::Long::Descriptive';
requires 'Moo';
requires 'Types::Standard';

on 'test' => sub {
    requires 'Test::Exception';
    requires 'Test::More';
    requires 'Test::Output';
};
