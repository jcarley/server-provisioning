class nginx {
  include nginx::dependencies, nginx::install, nginx::service
}

