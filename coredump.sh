
#!/bin/bash

echo /tmp/core-%e-%s-%u-%g-%p-%t > /proc/sys/kernel/core_pattern
ulimit -c unlimited
echo "kernel.core_uses_pid=1" >> /etc/sysctl.conf
echo "kernel.core_pattern=/tmp/core-%e-%s-%u-%g-%p-%t" >> /etc/sysctl.conf
echo "fs.suid_dumpable=2" >> /etc/sysctl.conf
sysctl -p