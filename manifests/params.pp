# == Class: bacula::params
#
# Default values for parameters needed to configure the <tt>bacula</tt> class.
#
# === Parameters
#
# None
#
# === Examples
#
#  include ::bacula::params
#
# === Copyright
#
# Copyright 2012 Russell Harrison
#
# === License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class bacula::params {
  $bat_console_package         = $::operatingsystem ? {
    /(Debian|Ubuntu)/ => 'bacula-console-qt',
    default           => 'bacula-console-bat',
  }
  $console_package             = 'bacula-console'
  $lib    = $::architecture ? {
    x86_64  => 'lib64',
    default => 'lib',
  }
  case $facts['os']['name'] {
    'RedHat', 'CentOS': {
      case $facts['os']['release']['major'] {
        /6/: {
          $director_mysql_package      = 'bacula-director-mysql'
          $director_postgresql_package = 'bacula-director-postgresql'
          $director_sqlite_package     = 'bacula-director-sqlite'
          $storage_mysql_package       = 'bacula-storage-mysql'
          $storage_postgresql_package  = 'bacula-storage-postgresql'
          $storage_sqlite_package      = 'bacula-storage-sqlite'
        }
        /7/: {
          $director_mysql_package      = 'bacula-libs-sql'
          $director_postgresql_package = 'bacula-libs-sql'
          $director_sqlite_package     = 'bacula-libs-sql'
          #$storage_mysql_package       = 'bacula-libs-sql'
          $storage_mysql_package       = 'telnet'
          $storage_postgresql_package  = 'bacula-libs-sql'
          $storage_sqlite_package      = 'bacula-libs-sql'
        }
        default: {
          fail("osrelease ${facts['os']['release']['major']}")
        }
      }
      $director_service            = 'bacula-dir'
      $libdir = "/usr/${lib}"
      $manage_logwatch = true
    }
    'Debian', 'Ubuntu': {
      $director_mysql_package      = 'bacula-director-mysql'
      $director_postgresql_package = 'bacula-director-pgsql'
      $director_sqlite_package     = 'bacula-director-sqlite'
      $director_service            = 'bacula-director'
      $libdir = '/usr/lib'
      $manage_logwatch = false
      $storage_mysql_package       = 'bacula-sd-mysql'
      $storage_postgresql_package  = 'bacula-sd-pgsql'
      $storage_sqlite_package      = 'bacula-sd-sqlite'
    }
    default:            {
      fail("osfamily")
    }
  }
  $director_server_default     = "bacula.${::domain}"
  $mail_command    = "/usr/sbin/bsmtp -h localhost -f bacula@${::fqdn} -s \\\"Bacula %t %e (for %c)\\\" %r"
  $mail_to_default = "root@${::fqdn}"
  $operator_command    = "/usr/sbin/bsmtp -h localhost -f bacula@${::fqdn} -s \\\"Bacula Intervention Required (for %c)\\\" %r"
  $plugin_dir           = "${libdir}/bacula"
  $storage_server_default      = "bacula.${::domain}"
}
