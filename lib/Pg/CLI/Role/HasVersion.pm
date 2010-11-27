package Pg::CLI::Role::HasVersion;
BEGIN {
  $Pg::CLI::Role::HasVersion::VERSION = '0.05';
}

use Moose::Role;

use namespace::autoclean;

use IPC::System::Simple qw( systemx );
use MooseX::Types::Moose qw( Str );
use Pg::CLI::pg_config;

has version => (
    is       => 'ro',
    isa      => Str,
    init_arg => '_version', # for testing
    lazy     => 1,
    builder  => '_build_version',
);

has two_part_version => (
    is       => 'ro',
    isa      => Str,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_two_part_version',
);

sub _build_version {
    my $self = shift;

    my $output = systemx( $self->executable(), '--version' );

    return $1 if $output =~ /(\d\.\d\.\d)/;
}

sub _build_two_part_version {
    my $self = shift;

    return $1 if $self->version() =~ /(\d\.\d)/;
}

1;
