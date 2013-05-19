class passenger::dependencies {
  if ! defined(Package['build-essential'])  { package { 'build-essential':  ensure => installed } }
  if ! defined(Package['libcurl4-openssl-dev'])  { package { 'libcurl4-openssl-dev':  ensure => installed } }
  if ! defined(Package['libssl-dev'])  { package { 'libssl-dev':  ensure => installed } }
}
