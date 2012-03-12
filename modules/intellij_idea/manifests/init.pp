class intellij_idea {
    include userinfo
    include oraclejava6

    $idea_install_path = '/opt/software/idea'

    file { 'idea-install-dir':
        path   => $idea_install_path,
        ensure => directory,
        owner  => $userinfo::user,
        group  => $userinfo::group,
    }

    intellij_idea { 'idea':
        installdir => $idea_install_path,
        owner      => $userinfo::user,
        group      => $userinfo::group,
        ensure     => present,
        require    => [ File['idea-install-dir'], Class['oraclejava6'] ],
    }
}
