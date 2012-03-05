class vim {
    include userinfo

    File {
        owner => $userinfo::user,
        group => $userinfo::user,
        mode  => "0600",
    }

    file { ".vimrc":
        path   => "$userinfo::user_homedir/.vimrc",
        source => "puppet:///modules/vim/vimrc",  
        ensure => file,
    }

    file { ".vim":
        path    => "$userinfo::user_homedir/.vim",
        source  => "puppet:///modules/vim/vim",  
        ensure  => directory,
        recurse =>  true,
    }
}
