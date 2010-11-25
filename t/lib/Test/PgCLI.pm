package Test::PgCLI;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT = 'test_command';

sub test_command {
    my $class = shift;
    my $run   = shift;
    my $tests = shift;

    $class = 'Pg::CLI::' . $class;

    no warnings 'redefine';
    no strict 'refs';

    local *{ $class . '::_call_systemx' } = $tests;

    $run->();
}

1;
