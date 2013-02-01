#!/usr/bin/env perl

use Test::More;
use Clustericious::Config;
use strict;

my $c = Clustericious::Config->new(\(my $a = <<'EOT'));
---
first  : one
second : two
third  : <%= conf->first %>
fourth : <%= conf->third %>
deep :
  under : water
h20 : <%= conf->deep->under %>
EOT

is $c->first, 'one', 'set yaml key';
is $c->second, 'two', 'set yaml key';
is $c->third, 'one', 'used conf helper';
is $c->fourth, 'one', 'used conf helper again';
is $c->h20, 'water', 'nested conf';

done_testing();

1;

