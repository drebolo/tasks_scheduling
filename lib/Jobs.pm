package Jobs;

use strict;
use warnings;

use Moo;
use Types::Standard qw/ArrayRef InstanceOf/;
use Job;

has job_list => (
    is      => 'rw',
    isa     => ArrayRef [ InstanceOf ['Job'] ],
    default => sub { [] }
);

has queue => (
    is      => 'rw',
    isa     => ArrayRef [ InstanceOf ['Job'] ],
    default => sub { [] }
);

sub process {
    my ( $self, $list ) = @_;
    $list = $self->_remove_spaces($list);
    my $comma_splited = $self->_split_by_comma($list);
    foreach my $val ( $comma_splited->@* ) {
        if ( $val =~ m/=>/ ) {
            $self->_add_with_dependency($val);
        }
        else {
            $self->_add_simple($val);
        }
    }

    # order alphabetically all jobs
    foreach my $j ( sort { $a->name cmp $b->name } $self->job_list->@* ) {

        # now order by dependecies
        $self->order_list($j);
    }
    return join ",", $self->queue->@*;
}

sub print_result {
    my ($self) = @_;
    if ( $self->queue->@* ) {
        print "jobs ordered list is: ", join( ",", $self->queue->@* ) . "\n";
    }
    else {
        print "no jobs provided\n";
    }
}

sub order_list {
    my ( $self, $j ) = @_;

    return if $j->is_visited;
    foreach my $dep ( $j->dependents->@* ) {
        $self->order_list($dep);
    }
    $j->is_visited(1);
    unshift $self->queue->@*, $j->name;

}

sub _add_with_dependency {
    my ( $self, $val ) = @_;

    my ( $v, $d ) = $self->_split_by_arrow($val);
    my $ej = $self->_find_by_name($v);
    if ( !$ej ) {
        $ej = Job->new( name => $v );
        push $self->job_list->@*, $ej;
    }
    if ($d) {
        my $eji = $self->_find_by_name($d);
        if ( !$eji ) {
            $eji = Job->new( name => $d );
            push $self->job_list->@*, $eji;
        }
        $eji->add_dependent($ej);
    }
}

sub _add_simple {
    my ( $self, $val ) = @_;

    my $j = $self->_find_by_name($val);
    if ( !$j ) {
        $j = Job->new( name => $val );
        push $self->job_list->@*, $j;
    }
}

sub _remove_spaces {
    my ( $self, $list ) = @_;
    $list =~ s/\s//g;
    return $list;
}

sub _split_by_comma {
    my ( $self, $list ) = @_;
    my @split = split /,/, $list;
    return \@split;
}

sub _split_by_arrow {
    my ( $self, $value ) = @_;
    my @split = split /=>/, $value;
    return @split;
}

sub _find_by_name {
    my ( $self, $name ) = @_;
    foreach my $j ( $self->job_list->@* ) {
        return $j if $j->name eq $name;
    }
}

1;
