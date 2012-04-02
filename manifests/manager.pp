class circus::manager {
    $check_delay = 5
    $endpoint = "tcp://127.0.0.1:5555"

    package {
        "circus":
            ensure => installed;
    }

    # Our puppet doesn't have an upstart service provider, yet. Sigh.
    #service {
    #    "circusd":
    #        ensure  => running,
    #        enable  => true,
    #        require => [
    #            File["/etc/init/circusd.conf"],
    #            File["/etc/circus.ini"],
    #        ];
    #}

    exec {
        "circusd-initctl-start":
            command => "/sbin/initctl start circusd",
            unless  => "/sbin/initctl status circusd | grep -w running",
            require => [
                Package["circus"],
                File["/etc/init/circusd.conf"],
                File["/etc/circus.ini"],
            ];
        "circus-initctl-reload":
            command     => "/sbin/initctl restart circusd",
            refreshonly => true;
    }

    file {
        "/etc/init/circusd.conf":
            ensure  => file,
            mode    => 0644,
            owner   => "root",
            group   => "root",
            source  => "puppet:///modules/circus/circusd.conf";
        "/etc/circus.ini":
            ensure  => file,
            mode    => 0644,
            owner   => "root",
            group   => "root",
            content => template("circus/circus.ini"),
            notify  => Exec["circus-initctl-reload"];
        "/etc/circus.d":
            ensure  => directory,
            mode    => 0755,
            owner   => "root",
            group   => "root";
    }
}
