class cprice-dev-env::prereqs {
    include userinfo

    package { 'ruby-open4':
        name   => 'libopen4-ruby',
        ensure => present,
    }

    file { '/opt/software':
        path   => '/opt/software',
        ensure => directory,
        owner  => $userinfo::user,
        group  => $userinfo::group,
        mode   => '0755',
    }
}
