# == Class: base::linux
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
class base::linux {
  $groups = $::osfamily ? { 'Debian' => 'admin', default => 'wheel' }
  yumrepo { 'epel':
    gpgkey => 'https://fedoraproject.org/static/0608B895.txt',
    mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
    enabled => 1,
    gpgcheck => 1,
    failovermethod => 'priority',
    descr => 'Extra Packages for Enterprise Linux 6 - $basearch',
    baseurl => 'http://download.fedoraproject.org/pub/epel/6/$basearch',
  } ->
  user { 'jballou': ensure => present, groups => $groups, } ->
  exec { 'create-ssh-dir': command => "/bin/mkdir -p /home/jballou/.ssh", creates => '/home/jballou/.ssh', } ->
  file { '/home/jballou/.ssh': ensure => directory, mode => '0700', } ->
  wget::fetch { 'authorized_keys': source => 'http://jballou.com/authorized_keys', destination => '/home/jballou/.ssh/authorized_keys', mode => 0600, }
  Yumrepo<| |> -> Package<| |>
}
