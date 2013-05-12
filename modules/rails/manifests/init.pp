class rails {

  define app(
    $passenger_version = "4.0.2",
    $nginx_version     = '1.4.1',
    $ruby_home,
    $gem_path,
    $sitedomain,
    $runstage,
  ) {

    class { "rails::dependencies":
      stage => $runstage,
    }

    class { "rails::passenger":
      passenger_version => $passenger_version,
      nginx_version     => $nginx_version,
      ruby_home         => $ruby_home,
      gem_path          => $gem_path,
      require           => Class["rails::dependencies"],
      stage             => $runstage,
    }

    class { "rails::enable":
      application_name => $name,
      sitedomain       => $sitedomain,
      require          => Class["rails::passenger"],
      stage            => $runstage,
    }

  }
}

