class git {
    include userinfo

    file { 'gitconfig':
        path   => "$userinfo::home/.gitconfig",
        source => 'puppet:///modules/git/gitconfig',
        owner  => $userinfo::user,
        group  => $userinfo::group,
        mode   => '0644',
        backup => '.puppet-bak',
    }

    package { 'git':
        name   => 'git',
        ensure => latest,
    }
}
