class nginx::dependencies {
  if ! defined(Package['build-essential'])              { package { 'build-essential':            ensure => installed } }
  if ! defined(Package['zlib1g'])                       { package { 'zlib1g':                     ensure => installed } }
  if ! defined(Package['zlib1g-dev'])                   { package { 'zlib1g-dev':                 ensure => installed } }
  if ! defined(Package['libssl-dev'])                   { package { 'libssl-dev':                 ensure => installed } }
  if ! defined(Package['libreadline-gplv2-dev'])        { package { 'libreadline-gplv2-dev':      ensure => installed } }
  if ! defined(Package['libyaml-dev'])                  { package { 'libyaml-dev':                ensure => installed } }
  if ! defined(Package['python-software-properties'])   { package { 'python-software-properties': ensure => installed } }
  if ! defined(Package['gcc-4.4'])                      { package { 'gcc-4.4':                    ensure => installed } }
  if ! defined(Package['libpcre3'])                     { package { 'libpcre3':                   ensure => installed } }
  if ! defined(Package['libpcre3-dev'])                 { package { 'libpcre3-dev':               ensure => installed } }
  if ! defined(Package['openssl'])                      { package { 'openssl':                    ensure => installed } }
  if ! defined(Package['curl'])                         { package { 'curl':                       ensure => installed } }
}

