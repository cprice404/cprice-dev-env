class gkrellm {
    include userinfo

    File {
        owner   => $userinfo::user,
        group   => $userinfo::group,
        mode    => "0644",
    }

    file { [ "$userinfo::home/.gkrellm2",
                "$userinfo::home/.gkrellm2/themes" ]:
        ensure => directory,
        before => File['modern_theme'],
    }

    file { 'modern_theme':
        path    => "$userinfo::home/.gkrellm2/themes/Modern",
        source  => 'puppet:///modules/gkrellm/themes/Modern',
        ensure  => directory,
        recurse => true,
    }
    
    file { "theme_config":
        path => "$userinfo::home/.gkrellm2/theme_config",
        source  => 'puppet:///modules/gkrellm/theme_config',
        ensure => file,
    }

    package { 'gkrellm':
        name   => 'gkrellm',
        ensure => 'installed',
    }
}
