#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok('Dist::Zilla::PluginBundle::FAYLAND');
}

diag(
"Testing Dist::Zilla::PluginBundle::FAYLAND $Dist::Zilla::PluginBundle::FAYLAND::VERSION, Perl $], $^X"
);
