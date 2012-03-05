class google-chrome {
    file { 'google-chrome.list':
        path => '/etc/apt/sources.list.d/google-chrome.list',
        source => 'puppet:///modules/google-chrome/etc/apt/sources.list.d/google-chrome.list',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    exec { 'chrome apt-key':
        command     => 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - ',
        path        => '/usr/bin',
        refreshonly => true,
        subscribe   => File['google-chrome.list'],
        notify      => Exec['apt-get update'],
    }

    exec { 'apt-get update':
        command     => 'apt-get update',
        path        => '/usr/bin',
        refreshonly => true,
    }

    package { 'google-chrome':
        name    => 'google-chrome-stable',
        ensure  => latest,
        require => Exec['apt-get update'],
    }

    
}
