package Pg::CLI::Role::Command;
BEGIN {
  $Pg::CLI::Role::Command::VERSION = '0.02';
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

__END__
=pod

=head1 NAME

Pg::CLI::Role::Command

=head1 VERSION

version 0.02

=head1 AUTHOR

Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Dave Rolsky.

This is free software, licensed under:

  The Artistic License 2.0

=cut

