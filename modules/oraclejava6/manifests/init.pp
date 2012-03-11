class oraclejava6 {
    include userinfo

    $java_install_path = '/opt/software/java'
    $java_home = "${java_install_path}/latest"
    $java_bin = "${java_home}/bin"

    file { 'java-install-dir':
        path   => $java_install_path,
        ensure => directory,
        owner  => $userinfo::user,
        group  => $userinfo::group,
    }

    oraclejava6 { 'java6':
        installdir => $java_install_path,
        owner      => $userinfo::user,
        group      => $userinfo::group,
        ensure     => present,
        require    => File['java-install-dir'],
    }

    append_if_no_such_line { 'set JAVA_HOME':
        file => '/etc/environment',
        line => "JAVA_HOME=\"${java_home}\"",
    }
    append_if_no_such_line { 'add java to path':
        file => '/etc/environment',
        line => "PATH=\"${java_bin}\":\$PATH",
    }
}
