class roles::www::passenger(
  $passenger_version = '4.0.2',
  $ruby_home,
  $gem_path,
  $application_name,
  $sitedomain
) {

  class { 'passenger::install':
    passenger_version => $passenger_version,
    ruby_home         => $ruby_home,
    gem_path          => $gem_path,
    stage             => $stage,
  }

  passenger::app { $application_name:
    sitedomain        => $sitedomain,
  }
}

