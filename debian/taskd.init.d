#!/bin/sh -e

### BEGIN INIT INFO
# Provides: taskd
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: taskwarrior sync server
# Description:       Multi-user sync server for taskwarrior clients
### END INIT INFO

DAEMON=/usr/bin/taskd
USER=Debian-taskd
PIDFILE=/run/taskd.pid
TASKDDATA=/var/lib/taskd
DESC='taskwarrior sync server'

test -f $DAEMON || exit 0

. /lib/lsb/init-functions

case "$1" in
    start)
        log_daemon_msg "Starting $DESC" "taskd"
        start-stop-daemon --oknodo --start --quiet --chuid $USER \
                          --pidfile $PIDFILE --exec $DAEMON \
                          -- \
                          server --data $TASKDDATA --daemon
        log_end_msg $?
        ;;
    stop)
        log_daemon_msg "Stopping $DESC" "taskd"
        start-stop-daemon --stop --pidfile $PIDFILE --retry 5 \
                          --exec $DAEMON --user $USER --oknodo --quiet
        log_end_msg $?
        ;;
    reload|force-reload|restart)
        log_daemon_msg "Restarting $DESC" "taskd"
        start-stop-daemon --stop --pidfile $PIDFILE --retry 5 \
                          --exec $DAEMON --user $USER --oknodo --quiet
        start-stop-daemon --oknodo --start --quiet --chuid $USER \
                          --pidfile $PIDFILE --exec $DAEMON \
                          -- \
                          server --data $TASKDDATA --daemon
        log_end_msg $?
        ;;
    *)
        echo "Usage: /etc/init.d/taskd {start|stop|restart}" >&2
        exit 1
        ;;
esac

exit 0
