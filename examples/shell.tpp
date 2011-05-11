--author Andreas Krennmair
--title Some shell examples
--date foobar
--newpage
--center Some "funny" shell tricks
This example shows some of the so-called "funny" shell tricks on csh/sh
--beginshelloutput
$ make love
Make: Don't know how to make love. Stop.
$ %blow
%blow: No such job.
$ PATH=pretending! /usr/ucb/which sense
no sense in pretending!
---
$ drink < bottle; opener
bottle: cannot open
opener: not found
---
$ If I had a ( for every $ Congress spent, what would I have?
Too many ('s.
$
--endshelloutput
---
And here some more text.
--newpage
--center And here some more serious shell things
--beginshelloutput
$ ls /
bin/    dev/     initrd/          lost+found/  repos/  tftpboot/  vmlinuz@
boot/   etc/     initrd.img@      mnt/         root/   tmp/       vmlinuz.old@
cdrom/  floppy/  initrd.img.old@  opt/         sbin/   usr/
data/   home/    lib/             proc/        sys/    var/
$ uptime
 23:22:41 up 23 days,  4:18,  8 users,  load average: 0.10, 0.25, 0.25
$ sleep 3
--sleep 3
$ uname -rnsm
Linux tintifax 2.6.6-1-686-smp i686
$
--endshelloutput
