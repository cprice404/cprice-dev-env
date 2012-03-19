class oraclejava6 {
    include userinfo

    $java_install_path = '/opt/software/java'
    $java_home = "${java_install_path}/latest"
    $java_bin = "${java_home}/bin"
    $java_env_vars_sh = '/etc/profile.d/java_env_vars.sh'

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

    file { 'java_env_vars.sh':
        path   => $java_env_vars_sh,
        owner  => root,
        group  => root,
        mode   => '0644',
        ensure => file,
    }

    append_if_no_such_line { 'set JAVA_HOME':
        file    => $java_env_vars_sh,
        line    => "export JAVA_HOME=\"${java_home}\"",
        require => File['java_env_vars.sh'],
    }
    append_if_no_such_line { 'add java to path':
        file => $java_env_vars_sh,
        line => "export PATH=\"${java_bin}\":\$PATH",
        require => File['java_env_vars.sh'],
    }
}
