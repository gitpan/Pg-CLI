package Pg::CLI::psql;
BEGIN {
  $Pg::CLI::psql::VERSION = '0.01';
}

use Moose;

use namespace::autoclean;

use MooseX::Params::Validate qw( validated_hash validated_list );
use MooseX::SemiAffordanceAccessor;
use MooseX::Types::Moose qw( ArrayRef Bool Str );

with 'Pg::CLI::Role::Command';

has quiet => (
    is      => 'ro',
    isa     => Bool,
    default => 1,
);

sub execute_file {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        database => { isa => Str },
        file     => { isa => Str },
        options  => { isa => ArrayRef [Str], default => [] },
    );

    push @{ $p{options} }, '-f', delete $p{file};

    $self->run(%p);
}

sub run {
    my $self = shift;
    my ( $database, $options ) = validated_list(
        \@_,
        database => { isa => Str },
        options  => { isa => ArrayRef [Str] },
    );

    $self->_execute_command(
        'psql',
        $self->_connect_options(),
        ( $self->quiet() ? '-q' : () ),
        @{$options},
        $database,
    );
}

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Wrapper for the F<psql> utility



=pod

=head1 NAME

Pg::CLI::psql - Wrapper for the F<psql> utility

=head1 VERSION

version 0.01

=head1 SYNOPSIS

  my $psql = Pg::CLI::psql->new(
      username => 'foo',
      password => 'bar',
      host     => 'pg.example.com',
      port     => 5433,
  );

  $psql->run(
      database => 'database',
      options  => [ '-c', 'DELETE FROM table' ],
  );

  $psql->execute_file(
      database => 'database',
      file     => 'thing.sql',
  );

=head1 DESCRIPTION

This class provides a wrapper for the F<psql> utility.

=head1 METHODS

This class provides the following methods:

=head2 Pg::CLI::psql->new( ... )

The constructor accepts a number of parameters:

=over 4

=item * username

The username to use when connecting to the database. Optional.

=item * password

The password to use when connecting to the database. Optional.

=item * host

The host to use when connecting to the database. Optional.

=item * port

The port to use when connecting to the database. Optional.

=item * quiet

This defaults to true. When true, the "-q" flag is passed to psql whenever it
is executed.

=back

=head2 $psql->run( database => ..., options => [ ... ] )

This method runs a command against the specified database. You must pass one
or more options that indicate what psql should do.

=head2 $psql->execute_file( database => ..., file => ... )

This method executes the specified file against the database. You can also
pass additional options via the C<options> parameter.

=head1 BUGS

See L<Pg::CLI> for bug reporting details.

=head1 AUTHOR

Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Dave Rolsky.

This is free software, licensed under:

  The Artistic License 2.0

=cut


__END__


