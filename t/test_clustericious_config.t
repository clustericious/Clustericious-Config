use strict;
use warnings;
use Test::Clustericious::Config;
use Test::More tests => 8;
use Clustericious::Config;

my $config_filename = create_config_ok 'Foo', { x => 1, y => 2 };
ok $config_filename && -r $config_filename, "$config_filename is readable";

my $config_foo = Clustericious::Config->new('Foo');

is eval { $config_foo->x }, 1, 'config_foo.x = 1';
is eval { $config_foo->y }, 2, 'config_foo.y = 2';

my $dir = create_directory_ok '/foo/bar/baz';
ok $dir && -d $dir, "directory really is there";

my $home = home_directory_ok;
ok $home && -d $home, "home really is there";
