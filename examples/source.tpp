--title Some Source Code Examples
--author Andreas Krennmair
--date today
--newpage
--center The Famous "Hello World" Source Code
--beginoutput
#include <stdio.h>

int main(void) {
  puts("Hello World");
  return 0;
}
--endoutput
--newpage
--center The Very Same Example, But This Time In Pieces
--beginoutput
#include <stdio.h>
---

int main(void) {
---
  puts("Hello World");
---
  return 0;
---
}
--endoutput
--newpage
--heading This is some example source code

--beginoutput
static void run_command(char *cmd, char *ip) {
  int pid;
  pid = fork();
  if (pid == 0) {
    char env_ip[20], env_cmd[strlen(cmd)+10];
    char *const envp[] = { env_ip, env_cmd, "PATH=/bin:/usr/bin", 0 };
    snprintf(env_cmd, sizeof(env_cmd), "CMD=%s", cmd);
    snprintf(env_ip, sizeof(env_ip), "IP=%s", ip);
    execle("/bin/sh", "/bin/sh", "-c", cmd, NULL, envp);
    limit_syslog(LOG_ERR, "execl of %s failed: %s", cmd, strerror(errno));
    exit(EXIT_FAILURE);
  } else if (pid == -1) {
    limit_syslog(LOG_ERR, "fork failed: %s", strerror(errno));
  } else {
    (void) waitpid(pid, NULL, 0);
  }
}
--endoutput
