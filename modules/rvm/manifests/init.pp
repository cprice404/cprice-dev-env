class rvm {
    include userinfo

    include rvm::dependencies


    Exec {
        path      => "$userinfo::home/.rvm/bin:/usr/bin:/usr/sbin:/bin",
        cwd       => $userinfo::home,
        user      => $userinfo::user,
        group     => $userinfo::group,
        timeout   => 600,
        logoutput => true,
    }

    exec { 'rvm':
        command   => 'curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer | bash -s stable',
        creates   => "$userinfo::home/.rvm/bin/rvm",
        require   => [ Class['rvm::dependencies'], ],
    }

    exec { 'ruby 1.8.7':
        command => 'rvm install 1.8.7-p334',
        creates => "$userinfo::home/.rvm/rubies/ruby-1.8.7-p334/bin/ruby",
        require => Exec['rvm'],
        notify  => Exec['default ruby'],
    }

    exec { 'ruby 1.9.2':
        command   => 'rvm install 1.9.2-p290',
        creates   => "$userinfo::home/.rvm/rubies/ruby-1.9.2-p290/bin/ruby",
        require   => Exec['rvm'],
    }

    exec { 'default ruby':
        command     => "rvm alias create default 1.8.7-p334",
        require     => Exec['ruby 1.8.7'],
        refreshonly => true,
    }

}
