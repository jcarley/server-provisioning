Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

include nginx

node default {
  nginx::site { "finishfirstsoftware.com" }
}
