package Pg::CLI::Role::Connects;
BEGIN {
  $Pg::CLI::Role::Connects::VERSION = '0.04';
}

use Moose::Role;

use namespace::autoclean;

use IPC::System::Simple qw( systemx );
use MooseX::Types::Moose qw( Str );

for my $attr (qw( username password host port )) {
    has $attr => (
        is        => 'rw',
        isa       => Str,
        predicate => '_has_' . $attr,
    );
}

sub _execute_command {
    my $self = shift;
    my $cmd  = shift;
    my @opts = @_;

    local $ENV{PGPASSWORD} = $self->password()
        if $self->_has_password();

    $self->_call_systemx($cmd,@opts);
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

    push @options, '-w';

    return @options;
}

1;
