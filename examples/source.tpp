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
