package Pg::CLI::Role::Connects;
BEGIN {
  $Pg::CLI::Role::Connects::VERSION = '0.07';
}

use Moose::Role;

use namespace::autoclean;

use IPC::System::Simple qw( systemx );
use MooseX::Types::Moose qw( Str );

with 'Pg::CLI::Role::HasVersion';

for my $attr (qw( username password host port )) {
    has $attr => (
        is        => 'rw',
        isa       => Str,
        predicate => '_has_' . $attr,
    );
}

has require_ssl => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

sub _execute_command {
    my $self = shift;
    my $cmd  = shift;
    my @opts = @_;

    local $ENV{PGPASSWORD} = $self->password()
        if $self->_has_password();

    local $ENV{PGSSLMODE} = 'require'
        if $self->require_ssl();

    $self->_call_systemx( $cmd, @opts );
}

# This is a separate sub to provide something we can override in testing
sub _call_systemx {
    shift;
    systemx(@_);
}

sub _connect_options {
    my $self = shift;

    my @options;

    push @options, '-U', $self->username()
        if $self->_has_username();

    push @options, '-h', $self->host()
        if $self->_has_host();

    push @options, '-p', $self->port()
        if $self->_has_port();

    push @options, '-w'
        if $self->two_part_version >= 8.4;

    return @options;
}

1;
