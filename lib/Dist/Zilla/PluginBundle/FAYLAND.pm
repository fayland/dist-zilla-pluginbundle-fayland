package Dist::Zilla::PluginBundle::FAYLAND;

# ABSTRACT: Dist::Zilla like FAYLAND when you build your dists

use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::PluginBundle';

=head1 SYNOPSIS
 
    # dist.ini
    [@FAYLAND]

It is equivalent to:

    [@Filter]
    bundle = @Classic
    remove = PodVersion
    remove = BumpVersion

    [PodWeaver]
    [PerlTidy]
    [Repository]
    [ReadmeFromPod]
    [CheckChangeLog]

=cut

use Dist::Zilla::PluginBundle::Filter;

sub bundle_config {
  my ($self, $arg) = @_;
  my $class = (ref $self) || $self;

  my @plugins = Dist::Zilla::PluginBundle::Filter->bundle_config({
    bundle => '@Classic',
    remove => [ qw(PodVersion BumpVersion) ],
  });

  push @plugins, (
    [ 'Dist::Zilla::Plugin::PodWeaver'      => { } ],
    [ 'Dist::Zilla::Plugin::PerlTidy'       => { } ],
    [ 'Dist::Zilla::Plugin::Repository'     => { } ],
    [ 'Dist::Zilla::Plugin::ReadmeFromPod'  => { } ],
    [ 'Dist::Zilla::Plugin::CheckChangeLog' => { } ],
  );

  eval "require $_->[0]" or die for @plugins; ## no critic Carp

  @plugins->map(sub { $_->[1]{'=name'} = "$class/$_->[0]" });

  return @plugins;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
