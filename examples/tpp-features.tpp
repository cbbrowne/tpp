--bgcolor white
--fgcolor black
--title TPP Feature Show
--author Andreas Krennmair
--date today
--newpage intro
--heading What is TPP?

  * A text console application
---

  * "Powerpoint for Sven G^W^Wtext tool users"
---

  * Simple file format, only text editor required
---

  * First version: 4-hour hack in Ruby + ruby-ncurses
---

  * Extension until source code was f*cked up,
    then complete rewrite w/ generic design
--newpage slide
--heading Basic TPP Features

  Simple text that is in one line
---

  What TPP also does is that it also takes very long lines, but doesn't simply output them, but break those long lines into a series of shorter ones, which are then printed to screen. Like this one. :-)
---

--center You can also center text (long lines will be wrapped, too)
---

--right And everything on the right side
---

--beginslideleft 
 * You can slide it in from the left
 * or from the right:
--endslideleft

--beginslideright
 * Like this line, for example
--endslideright
---
--beginslidetop
O R   L O O K   A T   T H I S ! ! !
--endslidetop
---
--beginslidebottom
O R   T H I S ! ! !
--endslidetop
--newpage attrib
--heading Attributes

This should be normal
---
--ulon
This should be underlined
---
--revon
This should be underlined and reverse
---
--boldon
This should be underlined, reverse and bold
--center This should be underlined, reverse, bold and centered
---
--uloff
This should be reverse and bold
---
--revoff
This should be bold
---
--boldoff
This should be normal again
--newpage keys
--heading Keys to Control TPP

--beginoutput
   space bar ............................... display next entry within page
   space bar, cursor-down, cursor-right .... display next page
   b, cursor-up, cursor-left ............... display previous page
   q, Q .................................... quit tpp
   j, J .................................... jump directly to page
   s, S .................................... jump to the first page
   e, E .................................... jump to the last page
   c, C .................................... start command line
   ?, h .................................... help screen
--endoutput
--newpage source
--heading Source Code Example

--beginoutput
  --##comment in the beginning
  --author Nico Golde <nico@ngolde.de> 
  --title Test for TPP
  --date today
  --withborder
  The next line in the source file is a comment and will not be displayed.
  --##This is the abstract, which is pretty cool.
  It consists of several lines.
  --newpage
  --withborder
  This is the next page, which also consists of
  several lines
  blubber. bla.
  --## comment somewhere else
  --newpage
  --withborder
  asdf jklö asdf jklö asdf jklö asdf jklö
--endoutput
--newpage other
--heading Other Things

This is supposed to be shell output:
--beginshelloutput
$ ls ~/bin
c89  cat  if.pl  seq  ssh-agent  ssh-agent.sh
$ cd ~/bin
$ ls -l
total 36
-rwxr-xr-x    1 ak       staff          27 Jul 11  2003 c89
-rwxr-xr-x    1 ak       staff       14732 Aug 26  2002 cat
-rwxr-xr-x    1 ak       staff         236 Apr 27  2003 if.pl
-rwxr-xr-x    1 ak       staff          73 Feb 19  2004 seq
-rwxr-xr-x    1 ak       staff         126 Dec 21 20:45 ssh-agent
-rwxr-xr-x    1 ak       staff          94 Jul 24 15:01 ssh-agent.sh
$ 
--endshelloutput
--newpage figlet
--heading FIGlet support!

--huge This is FIGlet
---
--sethugefont mini
--huge This is the mini font
--newpage future
--heading Future Goals

  * Release refactored version

---
  * More features (i.e. effects that make PowerPoint look lousy)

---
  * Stable support for export formats
--newpage thx
--heading Thanks To...
  
  * Nico Golde, the TPP co-author, who came up with lots of nice features, and brought TPP into Debian

  * Sven Guckes, who had the initial idea and established contact with Nico Golde, the TPP co-author

  * Alfie, for writing a VIM syntax file

  * arved, for bringing TPP into FreeBSD

  * Patricia "trish" Jung, for writing a very good article about TPP 
    - "Linux User" and
    - "Linux Magasinet" (Norway)
