# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Freeswitch](http://freeswitch.org/).

See the `Dockerfile` for further details.

The image is based on [Debian Jessie](https://www.debian.org/).

## Pre-requisites
[Overlay2](https://docs.docker.com/engine/userguide/storagedriver/overlayfs-driver/#configure-docker-with-the-overlay-or-overlay2-storage-driver) Docker storage driver.

# Getting started

Execute `run.sh`

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/voxbox/freeswitch/) and is the recommended method of installation.

```bash
docker pull voxbox/freeswitch:latest
```

Alternatively you can build the image yourself.

```bash
docker build -t freeswitch github.com/matteolc/docker-freeswitch
```

## Running

LimitRTTIME=infinity
= ionice -c 1 -n 2
= schedtool -R -p 89
= chrt -r 89 -a -p <pid>

### Ulimits
As we are not executing the service with systemd/sysv, we have to provide ulimits.

|Directive			| ulimit equivalent	| Unit                         |
|-------------------|-------------------|------------------------------|
|LimitCPU=			| ulimit -t			| Seconds                      |
|LimitFSIZE=		| ulimit -f			| Bytes                        |
|LimitDATA=			| ulimit -d			| Bytes                        |
|LimitSTACK=		| ulimit -s			| Bytes                        |
|LimitCORE=			| ulimit -c			| Bytes                        |
|LimitRSS=			| ulimit -m			| Bytes                        |
|LimitNOFILE=		| ulimit -n			| Number of File Descriptors   |
|LimitAS=			| ulimit -v			| Bytes                        |
|LimitNPROC=		| ulimit -u			| Number of Processes          |
|LimitMEMLOCK=		| ulimit -l			| Bytes                        |
|LimitLOCKS=		| ulimit -x			| Number of Locks              |
|LimitSIGPENDING=	| ulimit -i			| Number of Queued Signals     |
|LimitMSGQUEUE=		| ulimit -q			| Bytes                        |
|LimitNICE=			| ulimit -e			| Nice Level                   |
|LimitRTPRIO=		| ulimit -r			| Realtime Priority            |
|LimitRTTIME=		| No equivalent		| Microseconds                 |

### Capabilities

| Capability Key    | Capability Description                                                                                         |
|-------------------|----------------------------------------------------------------------------------------------------------------|  
|SYS_MODULE			| Load and unload kernel modules.                                                                                |
|SYS_RAWIO			| Perform I/O port operations (iopl(2) and ioperm(2)).                                                           |
|SYS_PACCT			| Use acct(2), switch process accounting on or off.                                                              |
|SYS_ADMIN			| Perform a range of system administration operations.                                                           |
|SYS_NICE			| Raise process nice value (nice(2), setpriority(2)) and change the nice value for arbitrary processes.          |
|SYS_RESOURCE		| Override resource Limits.                                                                                      |
|SYS_TIME			| Set system clock (settimeofday(2), stime(2), adjtimex(2)); set real-time (hardware) clock.                     |
|SYS_TTY_CONFIG		| Use vhangup(2); employ various privileged ioctl(2) operations on virtual terminals.                            |
|AUDIT_CONTROL		| Enable and disable kernel auditing; change auditing filter rules; retrieve auditing status and filtering rules.|
|MAC_OVERRIDE		| Allow MAC configuration or state changes. Implemented for the Smack LSM.                                       |
|MAC_ADMIN			| Override Mandatory Access Control (MAC). Implemented for the Smack Linux Security Module (LSM).                |
|NET_ADMIN			| Perform various network-related operations.                                                                    |
|SYSLOG				| Perform privileged syslog(2) operations.                                                                       |
|DAC_READ_SEARCH	| Bypass file read permission checks and directory read and execute permission checks.                           |
|LINUX_IMMUTABLE	| Set the FS_APPEND_FL and FS_IMMUTABLE_FL i-node flags.                                                         |
|NET_BROADCAST		| Make socket broadcasts, and listen to multicasts.                                                              |
|IPC_LOCK			| Lock memory (mlock(2), mlockall(2), mmap(2), shmctl(2)).                                                       |
|IPC_OWNER			| Bypass permission checks for operations on System V IPC objects.                                               |
|SYS_PTRACE			| Trace arbitrary processes using ptrace(2).                                                                     |
|SYS_BOOT			| Use reboot(2) and kexec_load(2), reboot and load a new kernel for later execution.                             |
|LEASE				| Establish leases on arbitrary files (see fcntl(2)).                                                            |
|WAKE_ALARM			| Trigger something that will wake up the system.                                                                |
|BLOCK_SUSPEND		| Employ features that can block system suspend.                                                                 |

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec` against the running container.

## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker vers6` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/docker-freeswitch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The container is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the T2Airtime project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/docker-freeswitch/blob/master/CODE_OF_CONDUCT.md).
