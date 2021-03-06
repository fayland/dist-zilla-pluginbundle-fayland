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
    remove = Readme

    [PodWeaver]
    [Test::Compile]
    [PerlTidy]
    [Repository]
    [ReadmeFromPod]
    [CheckChangeLog]
    [MetaJSON]
    [MinimumPerlFast]
    [Git::Contributors]

=cut

use Dist::Zilla::PluginBundle::Filter;


sub bundle_config {
  my ($self, $section) = @_;
  my $class = (ref $self) || $self;

  my $arg = $section->{payload};

  my @plugins = Dist::Zilla::PluginBundle::Filter->bundle_config({
    name    => "$class/Classic",
    payload => {
      bundle => '@Classic',
      remove => [ qw(PodVersion BumpVersion Readme) ],
    }
  });

  my $prefix = 'Dist::Zilla::Plugin::';
  my @extra = map {[ "$class/$prefix$_->[0]" => "$prefix$_->[0]" => $_->[1] ]}
  (
    [ PodWeaver      => { } ],
    [ 'Test::Compile'=> { } ],
    [ PerlTidy       => { } ],
    [ Repository     => { } ],
    [ ReadmeFromPod  => { } ],
    [ CheckChangeLog => { } ],
    [ MetaJSON       => { } ],
    [ MinimumPerlFast     => { } ],
    [ 'Git::Contributors' => { } ]
  );

  push @plugins, @extra;

  eval "require $_->[1]; 1;" or die for @plugins; ## no critic Carp

  return @plugins;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
