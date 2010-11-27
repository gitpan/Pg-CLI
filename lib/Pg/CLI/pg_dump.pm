package Pg::CLI::pg_dump;
BEGIN {
  $Pg::CLI::pg_dump::VERSION = '0.07';
}

use Moose;

use namespace::autoclean;

use MooseX::Params::Validate qw( validated_list );
use MooseX::SemiAffordanceAccessor;
use MooseX::Types::Moose qw( ArrayRef Bool Str );

with qw( Pg::CLI::Role::Connects Pg::CLI::Role::Executable );

sub run {
    my $self = shift;
    my ( $database, $options ) = validated_list(
        \@_,
        database => { isa => Str },
        options  => { isa => ArrayRef [Str], default => [] },
    );

    $self->_execute_command(
        'pg_dump',
        $self->_connect_options(),
        @{$options},
        $database,
    );
}

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Wrapper for the F<pg_dump> utility



=pod

=head1 NAME

Pg::CLI::pg_dump - Wrapper for the F<pg_dump> utility

=head1 VERSION

version 0.07

=head1 SYNOPSIS

  my $pg_dump = Pg::CLI::pg_dump->new(
      username => 'foo',
      password => 'bar',
      host     => 'pg.example.com',
      port     => 5433,
  );

  $pg_dump->run(
      database => 'database',
      options  => [ '-C' ],
  );

=head1 DESCRIPTION

This class provides a wrapper for the F<pg_dump> utility.

=head1 METHODS

This class provides the following methods:

=head2 Pg::CLI::pg_dump->new( ... )

The constructor accepts a number of parameters:

=over 4

=item * executable

The path to F<pg_dump>. By default, this will look for F<pg_dump> in your path
and throw an error if it cannot be found.

=item * username

The username to use when connecting to the database. Optional.

=item * password

The password to use when connecting to the database. Optional.

=item * host

The host to use when connecting to the database. Optional.

=item * port

The port to use when connecting to the database. Optional.

=item * require_ssl

If this is true, then the C<PGSSLMODE> environment variable will be set to
"require" when connecting to the database.

=back

=head2 $pg_dump->run( database => ..., options => [ ... ] )

This method dumps the specified database. Any values passed in C<options> will
be passed on to pg_dump.

=head2 $pg_dump->version()

Returns a the three part version as a string.

=head2 $pg_dump->two_part_version()

Returns the first two decimal numbers in the version.

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

