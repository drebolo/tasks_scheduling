package Job;

use Moo;
use Types::Standard qw/Bool ArrayRef InstanceOf StrMatch/;

has name => (
    is       => 'ro',
    required => 1,
    isa      => StrMatch [qr{^[a-z]+$}i]
);

has dependents => (
    is      => 'rw',
    isa     => ArrayRef [ InstanceOf ['Job'] ],
    default => sub { [] }
);

has is_visited => (
    is      => 'rw',
    isa     => Bool,
    default => 0
);

sub add_dependent {
    my ( $self, $dep ) = @_;

    # first check that can add dependents
    $self->_can_add_dependent($dep);
    push $self->dependents->@*, $dep;
}

sub _can_add_dependent {
    my ( $self, $dep ) = @_;

    die "Error: jobs can't depend on themselves.\n"
      if $self->name eq $dep->name;
    foreach my $d ( $dep->dependents->@* ) {
        die "Error: jobs can't have circular dependencies.\n"
          if $self->name eq $d->name;
        $self->_can_add_dependent($d);
    }
    return 1;
}

1;
