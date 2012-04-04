define circus::watcher($cmd, $args, $warmup_delay = 0, $numprocesses = 1,
                       $uid = "root", $gid = "root") {
    include circus::manager

    file {
        "/etc/circus.d/$name.ini":
            ensure  => file,
            mode    => 0644,
            owner   => "root",
            group   => "root",
            content => template("circus/watcher.ini"),
            notify  => Exec["circus-initctl-reload"];
    }

    exec {
        "circus-restart-$name":
            refreshonly => true,
            command     => "/usr/bin/circusctl restart $name";
    }
}
