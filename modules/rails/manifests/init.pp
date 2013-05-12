class rails {

  define app($ruby_home, $sitedomain, $runstage, $passenger_version = "4.0.2") {

    class { "rails::dependencies":
      stage => $runstage,
    }

    class { "rails::passenger":
      ruby_home         => $ruby_home,
      require           => Class["rails::dependencies"],
      passenger_version => $passenger_version,
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

