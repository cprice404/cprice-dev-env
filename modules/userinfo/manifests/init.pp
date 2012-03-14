class userinfo {
    # TODO: make these parameterized or dynamic
    $user = 'cprice'
    $home = '/home/cprice'
    $group = 'cprice'

    file { '~/bin':
        path   => "$home/bin",
        ensure => directory,
    }


    append_if_no_such_line { 'add ~/bin to PATH':
        file => "$home/.bashrc",
        line => "PATH=~/bin:\$PATH",
    }

}
