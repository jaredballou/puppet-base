# == Class: base
#
# Full description of class base here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'base':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class base {
  $cn = $::certname ? { '' => $::fqdn, default => $::certname, }
  $server = $::puppetmaster ? { '' => "puppet.${::domain}", default => $::puppetmaster, }
  Ini_setting { path => $::puppetconfig_config, section => 'agent', notify => Service[puppet], }
  ini_setting { 'puppet environment': setting => 'environment', value => $::environment, }
  ini_setting { 'puppet certname': setting => 'certname', value => $cn, }
  ini_setting { 'puppet server': setting => 'server', value => $server, }
  service { 'puppet': ensure => running, enable => true, }
  if ($osfamily == 'Windows') {
    include base::windows
  } else {
    include base::linux
  }
}
