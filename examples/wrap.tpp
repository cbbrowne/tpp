--author Andreas Krennmair
--title Wrapping long lines
--date today %a %b %e %H:%M:%S %Z %Y
This is oriented left. This is also quite long, also there to test how the line wrapping works. You will see examples for centered wrapping and right aligned wrapping later.
---
--center This is centered. And an extremely long line, so long that it is going to be wrapped at some point, wherever that is.
---
--right This is oriented right. Probably this line is even longer than the other, but this doesn't matter because this test must be as real as only possible. And I will make it even longer than planned, just to test how reliable it is, and whether it really aligns to the right.
---
--beginoutput
This is oriented left. This is also quite long, also there to test how the line wrapping works. You will see examples for centered wrapping and right aligned wrapping later.
---
--center This is centered. And an extremely long line, so long that it is going to be wrapped at some point, wherever that is.
---
--right This is oriented right. Probably this line is even longer than the other, but this doesn't matter because this test must be as real as only possible. And I will make it even longer than planned, just to test how reliable it is, and whether it really aligns to the right.
--endoutput
--newpage
--heading This is probably an overlong heading, but it's supposed to be the way it is, for testing purposes. One more sentence, and we have our test object.

This is normal text after the heading.
