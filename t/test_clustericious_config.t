use strict;
use warnings;
use Test::Clustericious::Config;
use Test::More tests => 12;
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


my $new_config_filename = create_config_ok 'Foo', { x => 3, y => 4 };
ok $new_config_filename && -r $new_config_filename, "$new_config_filename is readable";

my $new_config_foo = Clustericious::Config->new('Foo');

is eval { $new_config_foo->x }, 3, 'new_config_foo.x = 3';
is eval { $new_config_foo->y }, 4, 'new_config_foo.y = 4';
