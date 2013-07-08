=head1 NAME

Clustericious::Config::Plugin - Plugins for clustericious config files.

=head1 SYNOPSIS

 ---
 % extend_config 'SomeOtherConfig';

=head1 DESCRIPTION

This module provides the functions available in all configuration files
using L<Clustericious::Config>.

=head1 FUNCTIONS

=cut

package Clustericious::Config::Plugin;

use Hash::Merge qw/merge/;
use Data::Dumper;
use Carp qw( croak );
use strict;
use warnings;
use base qw( Exporter );

our $VERSION = '0.24';
our @mergeStack;
our @EXPORT = qw( extends_config get_password home file dir );

=head2 extends_config $config_name, %arguments

Extend the config using another config file.

=cut

sub extends_config {
    my $filename = shift;
    my @args = @_;
    push @mergeStack, Clustericious::Config->new($filename, \@args);
    return '';
}

#
#
# do_merges:
#
# Called after reading all config files, to process extends_config
# directives.
#
sub do_merges {
    my $class = shift;
    my $conf_data = shift; # Last one; Has highest precedence.

    return $conf_data unless @mergeStack;

    # Nested extends_config's form a tree which we traverse depth first.
    Hash::Merge::set_behavior( 'RIGHT_PRECEDENT' );
    my %so_far = %{ shift @mergeStack };
    while (my $c = shift @mergeStack) {
        my %h = %$c;
        %so_far = %{ merge( \%so_far, \%h ) };
    }
    %$conf_data = %{ merge( \%so_far, $conf_data ) };
}

=head2 get_password

Prompt for a password, if it is needed.

=cut

sub get_password {
    return Clustericious::Config::Password->sentinel;
}

=head2 home( [ $user ] )

Return the given users's home directory, or if no user is
specified return the calling user's home directory.

=cut

sub home (;$)
{
  require File::HomeDir;
  $_[0] ? File::HomeDir->users_home($_[0]) : File::HomeDir->my_home;
}

=head2 file( @list )

The C<file> shortcut from Path::Class, if it is installed.

=cut

sub file
{
  eval { require Path::Class::File };
  croak "file helper requires Path::Class" if $@;
  Path::Class::File->new(@_);
}

=head2 dir( @list )

The C<dir> shortcut from Path::Class, if it is installed.

=cut

sub dir
{
  require Path::Class::Dir;
  croak "dir helper requires Path::Class" if $@;
  Path::Class::File->new(@_);
}

=head1 SEE ALSO

L<Clustericious::Config>, L<Clustericious>

=cut

1;
