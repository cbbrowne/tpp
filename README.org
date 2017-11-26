* tpp - text presentation program

** What is tpp?

tpp stands for text presentation program and is an ncurses-based
presentation tool. The presentation can be written with your favorite
editor in a simple description format and then shown on any text
terminal that is supported by ncurses - ranging from an old VT100 to
the Linux framebuffer to an xterm.

** Installation

   Prerequisites: 
   * Ruby 1.8 <http://www.ruby-lang.org/>
   * a recent version of ncurses
   * ncurses-ruby <https://github.com/eclubb/ncurses-ruby>

   Optionally:
   * FIGlet (if you want to have huge text printed)

   Installing tpp:

   Just get root and type ~make install~

** Using tpp

Start tpp with the presentation file you would like to display:

#+BEGIN_EXAMPLE
$ tpp presentation.tpp
#+END_EXAMPLE

To control tpp, the following keys are available:
#+BEGIN_EXAMPLE
space bar, cursor-down, cursor-right ... display next page
b, cursor-up, cursor-left .............. display previous page
q, Q ................................... quit tpp
j, J ................................... jump directly to page
l, L ................................... reload current file
s, S ................................... jump to the start page
e, E ................................... jump to the last page
c, C ................................... start command line
?, h ................................... show help screen
#+END_EXAMPLE

On the lower left side of your terminal you will notice the current slide
number and the total number of slides. Left of that, a '*' will appear when
the end of the current slide has been reached. If no '*' appears,
pressing space bar the next time will show the next entry on the page
(separated by '---'). You are also able to go to the next/previous page at
this point.

When you press 'l' (lower-case L) or 'L', the file you have currently loaded
into tpp will be reloaded from disk. This is very useful when you write
presentations with tpp, and constantly need a preview.

[[https://i.imgur.com/dJBxz0x.gif]]

** Writing tpp presentations

The tpp presentation formats consists of normal text lines and special
commands. Special commands are contained in lines that begin with "--"
and the command name.

The presentation is divided into 1 or more pages, which are separated by
the "--newpage". Before the first "--newpage" is encountered, all
non-command text is used as the presentation's abstract. Here, the
title, the author and the date can be set, too. You can also optionally
specify a name for a page: append it to the "--newpage" command,
separated by a single blank. If no name is set, a name will be
automatically generated.

The following commands are allowed in the abstract page:

--author: sets the author of the presentation

--title: sets the title of the presentation

--date: sets the date of the presentation. If the date is "today", today's
    date is inserted instead. You can set a custom format string if you append 
    it after "today", separated by a blank. Date formats are like formats for 
    date(1), and documented in this manual page. If no format string is supplied,
    "%b %d %Y" is assumed as default.

--bgcolor <color>: the background color is set to <color>.

--fgcolor <color>: the foreground color is set to <color>.

Valid colors are white, yellow, red, green, blue, cyan, magenta, black and default for transparency.

Within a page, so-called "page-local" commands can be used. The
following page-local commands are available:

--heading <heading>: draw a heading. Headings will be centered and drawn
    in bold (if supported by the terminal).

--horline: draws a horizontal line in the current line

--header: adds text to the first line on the screen

--footer: adds text to the last line on the screen

--color <color>: draw the text with specified color until a new color is set

--center <text>: center <text>. The text will be drawn centered.

--right <text>: draw <text> right-oriented. When drawing the text, it
    will be aligned on the right side of the terminal.

---: stop drawing until space bar has been pressed.

--beginoutput: marks the beginning of a framed output

--endoutput: marks the end of a framed output

--beginshelloutput: marks the beginning of a framed shell output. The
    difference between normal output and shell output is that lines that
    start with $,%, or # are printed as if they were typed by a person.

--endshelloutput: marks the end of a shell output

--sleep <seconds>: tpp stops for 3 seconds, doing nothing and accepting
    no input.
    
--boldon: switches on bold printing
--boldoff: switches off bold printing

--revon: switches on reverse printing (i.e. reverse fg and bg colors)
--revoff: switches off reverse printing

--ulon: switches on underlined printing
--uloff: switches off underlined printing

--huge <text>: <text> is drawn in huge letters. FIGlet is used to
    generate the huge letters.

--sethugefont <font>: If you use --huge FIGlet will use 
    the specified <font> to generate the huge letters.
	You will find the names of the available fonts in the figlet manual.

--exec <cmd>: executes <cmd>. Useful for e.g. starting image viewers.

--beginslideleft: starts the "slide in from left" mode
--endslideleft: ends the "slide in from left" mode

--beginslideright: starts the "slide in from right" mode
--endslideright: ends the "slide in from right" mode

--beginslidetop: starts the "slide in from the top" mode
--endslidetop: ends the "slide in from the top" mode

--withborder: makes a border around the current page

--beginslidebottom: starts the "slide in from the bottom" mode
--endslidebottom: ends the "slide in from the bottom" mode

$$ cmd : append the stdout of executing cmd in the shell
$% cmd : append the stdout of executing cmd in the shell with % at the beginning of every line(useful with --beginshelloutput).

You can comment lines using --##

** Examples

For a collection of examples that demonstrate the different features
of tpp, please have a look into the examples subdirectory in the tpp
source distribution.

** Options:

tpp --help: displays help in text mode
tpp -l output input.tpp: converts tpp file into a LaTeX slide
tpp --version: displays version number

The LaTeX slide output option is currently unsupported and will most likely not
work correctly!

** Vim syntax file

To use the vim syntax file you have to copy the tpp.vim file into ~/.vim/syntax/.
If the directory does not exist you have to create it.
In the next step you have to copy the following into ~/.vim/filetype.vim:

#+BEGIN_EXAMPLE
if exists("did_load_filetypes")
	finish
endif
augroup filetype detect
	au! BufRead,BufNewFile *.tpp  setfiletype tpp
augroup END
#+END_EXAMPLE

If your vim editor does not use syntax highlighting in the default setup you have to
change to the vim command mode and type: syntax on.

Beside the tpp.vim in the contrib subdirectory, there's also another, more sophisticated
version, which we unfortunately cannot distribute due to license reason. You can find
this file at http://www.trish.de/downloads/tpp.vim

** OSX TextWrangler/BBEdit syntax file

To use the TextWrangler syntax file you have to copy the TPP.plist
file into ~/Library/Application Support/TextWrangler/Language Modules/.

** License

tpp - text presentation program                                                               

Copyright (C) 2004-2005, 2007 Andreas Krennmair <ak@synflood.at>, Nico Golde <nico@ngolde.de> 
                                                                                                
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.
                                                                                                
This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.
                                                                                               
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA
                                                                                                


