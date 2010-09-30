#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'GrotSpot';
all_from 'lib/GrotSpot.pm';

requires 'Cache::Memcached::libmemcached';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Model::Factory::PerRequest';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Runtime' => '5.80022';
requires 'Config::General';
requires 'Data::GUID';
requires 'parent';
requires 'Template::Plugin::Comma';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
