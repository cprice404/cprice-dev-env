class konsole {
    include userinfo

    File {
        owner => $userinfo::user,
        group => $userinfo::user,
        mode => "0600",
    }

    file { 'konsole':
        path    => "$userinfo::user_homedir/.kde/share/apps/konsole",
        source  => "puppet:///modules/konsole/kde/share/apps/konsole",
        ensure  => directory,
        recurse => true,
    }
}
