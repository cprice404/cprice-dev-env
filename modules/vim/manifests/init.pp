class vim {
    include userinfo

    File {
        owner => $userinfo::user,
        group => $userinfo::group,
        mode  => "0600",
    }

    file { ".vimrc":
        path   => "$userinfo::home/.vimrc",
        source => "puppet:///modules/vim/vimrc",  
        ensure => file,
        backup => '.puppet-bak',
    }

    file { ".vim":
        path    => "$userinfo::home/.vim",
        source  => "puppet:///modules/vim/vim",  
        ensure  => directory,
        recurse =>  true,
        backup => '.puppet-bak',
    }
}
