class rvm::dependencies {

    define ensure_installed {
       if ! defined(Package[$title])      {
           package { "$title":
               ensure => installed
           }
       }
    }

    ensure_installed { 'build-essential': }
    ensure_installed { 'bison': }
    ensure_installed { 'openssl': }
    ensure_installed { 'libreadline6': }
    ensure_installed { 'libreadline6-dev': }
    ensure_installed { 'curl': }
    ensure_installed { 'zlib1g': }
    ensure_installed { 'zlib1g-dev': }
    ensure_installed { 'libssl-dev': }
    ensure_installed { 'libyaml-dev': }
    ensure_installed { 'libsqlite3-0': }
    ensure_installed { 'libsqlite3-dev': }
    ensure_installed { 'sqlite3': }
    ensure_installed { 'libxml2-dev': }
    ensure_installed { 'libxslt1-dev': }
    ensure_installed { 'autoconf': }
    ensure_installed { 'libc6-dev': }
}
