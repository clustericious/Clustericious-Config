package Clustericious::Command::configdebug;
 
use strict;
use warnings;
use v5.10;
use Mojo::Base 'Clustericious::Command';
use Clustericious::Config;
use YAML::XS qw( Dump );

our $VERSION = '0.24_03';

has description => <<EOT;
print the various stages of the clustericious app configuration file
EOT

has usage => <<EOT;
usage $0: configdebug
print the various stages of the clustericious app configuration file
EOT

sub run
{
  my $self = shift;
  my $app_name = $_[0] || ref($self->app);

  $ENV{MOJO_TEMPLATE_DEBUG} = 1;
  $ENV{CLUSTERICIOUS_CONFIG_SAVE_RENDERED} = 1;

  my $callback1 = sub
  {
    my($class, $src) = @_;
    my $data;
    if(ref $src)
    {
      say "[SCALAR :: template]";
      $data = $$src;
    }
    else
    {
      say "[$src :: template]";
      open my $fh, '<', $src;
      local $/;
      $data = <$fh>;
      close $fh;
    }
    chomp $data;
    say $data;
  };

  my $callback2 = sub
  {
    my($class, $file, $content) = @_;
    say "[$file :: interpreted]";
    chomp $content;
    say $content;
  };

  # place the hooks in Clustericious::Config which usually
  # doesn't do this debugging stuff.
  do { no warnings; *Clustericious::Config::pre_rendered = $callback1; };
  do { no warnings; *Clustericious::Config::rendered     = $callback2; };

  my $config = Clustericious::Config->new($app_name);

  say "[merged]";
  print Dump({ %$config });

};

1;
