use strict;
use warnings;

use lib 't/lib';

use Pg::CLI::psql;
use Test::More 0.88;
use Test::PgCLI;

{
    my $psql = Pg::CLI::psql->new( executable => 'foo' );

    test_command(
        'psql',
        sub {
            $psql->run(
                database => 'Foo',
                options  => [ '-c', 'SELECT 1 FROM foo' ]
            );
        },
        sub {
            shift;
            my @cmd = @_;

            ok(
                !$ENV{PGPASSWORD},
                'password is not set in environment when command runs'
            );
            ok(
                !$ENV{PGSSLMODE},
                'ssl mode is not set in environment when command runs'
            );
            is_deeply(
                \@cmd,
                [
                    'psql',
                    '-w',
                    '-q',
                    '-c', 'SELECT 1 FROM foo',
                    'Foo'
                ],
                'command includes options and -w, but no other connection info'
            );
        },
    );

    test_command(
        'psql',
        sub {
            $psql->execute_file(
                database => 'Foo',
                file     => 'thing.sql',
            );
        },
        sub {
            shift;
            my @cmd = @_;

            ok(
                !$ENV{PGPASSWORD},
                'password is not set in environment when command runs'
            );
            is_deeply(
                \@cmd,
                [
                    'psql',
                    '-w',
                    '-q',
                    '-f', 'thing.sql',
                    'Foo'
                ],
                'command includes -f and file name'
            );
        },
    );
}

{
    my $psql = Pg::CLI::psql->new(
        executable  => 'foo',
        username    => 'foo',
        password    => 'bar',
        host        => 'foo.example.com',
        port        => 5141,
        require_ssl => 1,
    );

    test_command(
        'psql',
        sub {
            $psql->run(
                database => 'Foo',
                options  => [ '-c', 'SELECT 1 FROM foo' ]
            );
        },
        sub {
            shift;
            my @cmd = @_;

            is(
                $ENV{PGPASSWORD}, 'bar',
                'password is set in environment when command runs'
            );
            is(
                $ENV{PGSSLMODE}, 'require',
                'ssl mode is set in environment when command runs'
            );
            is_deeply(
                \@cmd,
                [
                    'psql',
                    '-U', 'foo',
                    '-h', 'foo.example.com',
                    '-p', 5141,
                    '-w',
                    '-q',
                    '-c', 'SELECT 1 FROM foo',
                    'Foo'
                ],
                'command includes connection info'
            );
        },
    );
}

done_testing();
