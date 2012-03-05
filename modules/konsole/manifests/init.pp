class konsole {
    include userinfo

    File {
        owner => $userinfo::user,
        group => $userinfo::group,
        mode => "0600",
        backup => '.puppet-bak',
    }

    $source = "puppet:///modules/konsole/kde/share/apps/konsole"
    $target = "$userinfo::home/.kde/share/apps/konsole"

    file { 'TransparentMinty.colorscheme':
        path   => "$target/TransparentMinty.colorscheme",
        source => "$source/TransparentMinty.colorscheme",
        ensure => file,
    }

    file { 'MintyShell.profile':
        path    => "$target/MintyShell.profile",
        source  => "$source/MintyShell.profile",
        ensure  => file,
    }

    file { 'MintyShell-smallfont.profile':
        path    => "$target/MintyShell-smallfont.profile",
        source  => "$source/MintyShell-smallfont.profile",
        ensure  => file,
    }
}
