package Clustericious::Config::Password;

use Data::Dumper;
use IO::Prompt qw/prompt/;

use strict;
use warnings;

our $Stashed;

sub sentinel {
    return "__XXX_placeholder_ceaa5b9c080d69ccdaef9f81bf792341__";
}

sub get {
    my $self = shift;
    $Stashed ||= prompt ("Password:",-e=>'*');
    $Stashed;
}

sub is_sentinel {
    my $class = shift;
    my $val = shift;
    return (defined($val) && $val eq $class->sentinel);
}

1;

