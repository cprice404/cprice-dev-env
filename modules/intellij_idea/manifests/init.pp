class intellij_idea {
    include userinfo
    include oraclejava6

    $idea_install_path = '/opt/software/idea'

    File {
        owner  => $userinfo::user,
        group  => $userinfo::group,
    }

    file { 'idea-install-dir':
        path   => $idea_install_path,
        ensure => directory,
    }

    intellij_idea { 'idea':
        installdir => $idea_install_path,
        owner      => $userinfo::user,
        group      => $userinfo::group,
        ensure     => present,
        require    => [ File['idea-install-dir'], Class['oraclejava6'] ],
    }

    file { '~/bin/idea':
        path   => "$userinfo::home/bin/idea",
        mode   => "0755",
        source => 'puppet:///modules/intellij_idea/bin/idea',
        ensure => file,
    }
    
    initial_config_file { '~/.IntelliJIdea11':
        path    => "$userinfo::home/.IntelliJIdea11",
        mode    => "0644",
        source  => 'puppet:///modules/intellij_idea/IntelliJIdea11',
        ensure  => directory,
        recurse => true,
    }

    #notify { "FOOCHONKY!": }
    #
    #exec { "check existence of IDEA config dir":
    ###command => "/bin/echo '$httpd_extras_text' > $httpd_extras_file",
    #command  => "/bin/echo 'hi.'",
    #onlyif   => "/usr/bin/test -d $userinfo::home/.IntelliJIdea11",
    #notify   => Notify["FOOCHONKY!"],
    #}
}
