class git {
    include userinfo

    file { 'gitconfig':
        path   => "$userinfo::user_homedir/.gitconfig",
        source => 'puppet:///modules/git/gitconfig',
        owner  => "$userinfo::user",
        group  => "$userinfo::user",
        mode   => '0644',
    }

    package { 'git':
        name   => 'git',
        ensure => latest,
    }
}
