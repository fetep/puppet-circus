## Dependencies

You have a package named "circus" that installs:

* /usr/bin/circusd
* /usr/bin/circusctl

You are running some OS that uses Upstart, with configuration files in
/etc/init/ and an initctl in /sbin.

## System Layout

Installs a global /etc/circus.ini, and each circus::watcher instance gets
a config file under /etc/circus.d/.  The circus daemon is configured to log
to /var/log/circus.log, and store a pid file as /var/run/circusd.pid.

## Example Usage

This puppet code:

    circus::watcher {
        "test-sleep":
            cmd  => "/bin/bash",
            args => "-c 'sleep 30'",
            numprocesses => 3;
    }

Creates a config file that looks like this:

    [watcher:petef-test]
    cmd = /bin/bash
    args = -c 'sleep 30'
    warmup_delay = 0
    numprocesses = 1

And generates a puppet exec resource you can use to notify when you want to
restart your program:

    file {
        "/some/config":
            ensure => file,
            source => "...",
            notify => Exec["circus-restart-petef-test"];
    }
