#!/usr/bin/ruby

require "ncurses"
include Ncurses

class ColorMap

  def ColorMap.get_color(color)
    colors = { "white" => COLOR_WHITE,
               "yellow" => COLOR_YELLOW,
               "red" => COLOR_RED,
               "green" => COLOR_GREEN,
               "blue" => COLOR_BLUE,
               "cyan" => COLOR_CYAN,
               "magenta" => COLOR_MAGENTA,
               "black" => COLOR_BLACK }
    colors[color]
  end

  def ColorMap.get_color_pair(color)
    colors = { "white" => 1,
               "yellow" => 2,
               "red" => 3,
               "green" => 4,
               "blue" => 5,
               "cyan" => 6,
               "magenta" => 7,
               "black" => 8 }
    colors[color]
  end

end

class Page

  def initialize(name)
   @lines = []
   @name = name
  end

  def name
    @name
  end

  def set_name(n)
    @name = n
  end

  def lines=(l)
    @lines = l
  end

  def add_line(l)
    @lines << l
  end

  def add_lines(l)
    l.each { |x| @lines << l }
  end

  def set_lines(l)
    @lines = l
  end

  def lines
    @lines
  end

  def print
    @lines.each do |l|
      puts l
    end
  end

end



class LatexGenerator

  def initialize(pages,title,author,date)
    @pages = pages
    @title = title
    @author = author
    @date = date
  end

  def generate_output(fn)
    @fh = File.new(fn,"w+") or begin
      $stderr.puts "error: couldn't open #{fn} for writing!\n"
      Kernel.exit(1)
    end

    print_frontpage
    @pages.each_index do |i|
      print_page(i)
    end
    print_footer
  end

  def print_frontpage
    @fh.puts "\\documentclass[slifonts,a4,landscape]{powersem}

\\usepackage[display,slifonts]{texpower}

\\usepackage[T1]{fontenc}
\\usepackage{umlaut}
\\usepackage[german]{babel}
\\usepackage{pslatex}
\\usepackage{fixseminar}
\\title{#{@title}}
\\author{#{@author}}
\\date{#{@date}}

\\begin{document}

\\thispagestyle{plain}
\\maketitle
"

  end

  def print_footer
    @fh.puts '\end{document}'
  end

  def print_line(l)
    case l
      when /^--heading /
        heading = l.sub(/^--heading /,"")
        @fh.puts "\\section*{#{heading}}"
      when /^--center /
        text = l.sub(/^--center /,"")
        @fh.puts "\\begin{center}#{text}\\end{center}"
      when /^--right /
        text = l.sub(/^--right /,"")
        @fh.puts "\\begin{right}#{text}\\end{right}"
      when /^---/,/^--sleep/,/--beginslide/,/--endslide/,/^--color/
        # do nothing
      when /^--beginoutput/,/^--beginshelloutput/
        @fh.puts '\begin{verbatim}'
      when /^--endoutput/,/--endshelloutput/
        @fh.puts '\end{verbatim}'
      when /^--boldon/
        @fh.puts '{\bf '
      when /^--revon/,/^--ulon/
        @fh.puts '{\it '
      when /^--boldoff/,/^--revoff/,/^--uloff/
        @fh.puts '}'
      when /^--huge /
        text = l.sub(/^--huge /,"")
        @fh.puts "{\\huge #{text}}"
      else
        @fh.puts("#{l}")
    end
  end

  def print_page(i)
    if i == 0 then
      @fh.puts '\begin{abstract}'
      @pages[i].lines.each do |l|
        print_line(l)
      end
      @fh.puts '\end{abstract}'
    else
      @pages[i].lines.each do |l|
        print_line(l)
      end
    end
    @fh.puts '\newpage'
  end


end


class FileParser

  def initialize(filename)
    @filename = filename
    @pages = [ nil ]
    @bgcolor = "black"
    @fgcolor = "white"
  end

  def do_work
    f = File.open(@filename)

    if not f then
      $stderr.puts "Couldn't open #{@filename}."
      Kernel.exit(1)
    end

    cur_page = nil

    @title = ""
    @author = ""
    @date = ""
    abstract = []

    number_pages = 0

    f.each_line do |line|
      line.chomp!
      case line
        when /^--title / # store title
          @title = line.sub(/^--title /,"")
        when /^--author / # store author
          @author = line.sub(/^--author /,"")
        when /^--date / # store date
          @date = line.sub(/^--date /,"")
          if @date == "today" then
            @date = Time.now.strftime("%b %d %Y")
          end
        when /^--bgcolor /
          @bgcolor = line.sub(/^--bgcolor /,"")
        when /^--fgcolor /
          @fgcolor = line.sub(/^--fgcolor /,"")
        when /^--newpage/
          if cur_page then
            @pages << cur_page
          end
          number_pages += 1
          name = line.sub(/^--newpage/,"")
          if name == "" then
            name = "slide " + (number_pages+1).to_s 
          else
            name.strip!
          end
          cur_page = Page.new(name)
        else
          if number_pages == 0 then
            abstract << line # lines before the first page are the abstract
          else
            cur_page.add_line(line)
          end
      end
    end

    if cur_page and cur_page.lines.size > 0 then
      @pages << cur_page
    end

    front_page = Page.new("#{@title}")
    fp_lines = ["--color #{@fgcolor}",
                "--heading #{@title}",
                "",
                "--center #{@author}",
                "--center #{@date}",
                "" ]
    abstract.each { |al| fp_lines << al }
    front_page.set_lines(fp_lines)
    @pages[0] = front_page
  end

  def get_title
    @title
  end

  def get_author
    @author
  end

  def get_date
    @date
  end

  def get_bgcolor
    if @bgcolor then
      @bgcolor
    else
      "black"
    end
  end

  def get_pages
    @pages
  end

end


class Pager

  def initialize(pages,bgcolor)
    @pages = pages
    Ncurses.initscr
    Ncurses.curs_set(0)
    Ncurses.cbreak # unbuffered input
    Ncurses.noecho # turn off input echoing
    Ncurses.stdscr.intrflush(false)
    Ncurses.stdscr.keypad(true)
    Ncurses.start_color()
    @bgcolor = ColorMap.get_color(bgcolor) or COLOR_BLACK
    Ncurses.init_pair(1, COLOR_WHITE, @bgcolor)
    Ncurses.init_pair(2, COLOR_YELLOW, @bgcolor)
    Ncurses.init_pair(3, COLOR_RED, @bgcolor)
    Ncurses.init_pair(4, COLOR_GREEN, @bgcolor)
    Ncurses.init_pair(5, COLOR_BLUE, @bgcolor)
    Ncurses.init_pair(6, COLOR_CYAN, @bgcolor)
    Ncurses.init_pair(7, COLOR_MAGENTA, @bgcolor)
    Ncurses.init_pair(8, COLOR_BLACK, @bgcolor)
    Ncurses.bkgd(Ncurses.COLOR_PAIR(1));
    @current_page = 0
    @current_color_pair = 1
    @number_pages = @pages.size
    @indent = 5
    @voffset = 3
    @screen = Ncurses.stdscr
    set_sizes
  end

  def close
    Ncurses.nocbreak
    Ncurses.endwin
  end

  def set_sizes(sig = nil)
    @termwidth = Ncurses.getmaxx(@screen)
    @termheight = Ncurses.getmaxy(@screen)
  end

  def read_newpage
    page = []
    @screen.clear()
    col = 0
    line = 2
    @pages.each_index do |i|
      @screen.move(line,col*15 + 2)
      @screen.printw("%2d %s",i+1,@pages[i].name[0..10])
      line += 1
      if line >= @termheight - 3 then
        line = 2
        col += 1
      end
    end
    prompt = "jump to slide: "
    prompt_indent = 12
    @screen.move(@termheight - 2, @indent + prompt_indent)
    @screen.addstr(prompt)
    # @screen.refresh();
    Ncurses.echo
    @screen.scanw("%d",page)
    Ncurses.noecho
    @screen.move(@termheight - 2, @indent + prompt_indent)
    (prompt.length + page[0].to_s.length).times { @screen.addstr(" ") }
    if page[0] then
      return page[0] - 1
    end
    return -1 # invalid page
  end
  
  def draw_slidenum
    @screen.move(@termheight - 2, @indent)
    # @screen.attroff(Ncurses.COLOR_PAIR(@current_color_pair))
    @screen.attroff(Ncurses::A_BOLD) # this is bad
    @screen.addstr("[slide #{@current_page+1}/#{@number_pages}]")
  end

  def draw_eop_marker
    @screen.move(@termheight - 2, @indent - 1)
    @screen.attron(A_BOLD)
    @screen.addstr("*")
    @screen.attroff(A_BOLD)
  end

  def draw_border
    y = 1 
    @screen.move(0,0)
    @screen.addstr(".")
    (@termwidth-2).times { @screen.addstr("-") }; @screen.addstr(".")
    @screen.move(@termheight-2,0)
    @screen.addstr("`")
    (@termwidth-2).times { @screen.addstr("-") }; @screen.addstr("'")
    while y <= @termheight-3
      @screen.move(y,0)
	  @screen.addstr("|") 
      y += 1
    end
    y=1 
    while y <= @termheight-3
      @screen.move(y,@termwidth-1)
	  @screen.addstr("|") 
      y += 1
    end
  end

  def type_line(l)
    l.each_byte do |x|
      @screen.addstr(x.chr)
      @screen.refresh()
      r = rand(20)
      time_to_sleep = (5 + r).to_f / 250;
      # puts "#{time_to_sleep} #{r}"
      Kernel.sleep(time_to_sleep)
    end
  end
  def command_prompt()
    message = "Press any key to continue :)"
    cursor_pos = 0
    max_len = 50
    prompt = "tpp@localhost:~ $ "
    string = ""
    window = @screen.dupwin
    Ncurses.overwrite(window,@screen) # overwrite @screen with window
    Ncurses.curs_set(1)
    Ncurses.echo
    window.move(@termheight/4,1)
    window.clrtoeol()
    window.clrtobot()
    window.mvaddstr(@termheight/4,1,prompt) # add the prompt string

    loop do
      window.mvaddstr(@termheight/4,1+prompt.length,string) # add the code
      window.move(@termheight/4,1+prompt.length+cursor_pos) # move cursor to the end of code

      ch = window.getch
      case ch
        when Ncurses::KEY_LEFT
          cursor_pos = [0, cursor_pos-1].max # jump one character to the left
        when Ncurses::KEY_RIGHT
          cursor_pos = [0, cursor_pos+1].max # jump one character to the right
        when Ncurses::KEY_ENTER, ?\n, ?\r
          Ncurses.curs_set(0)
          Ncurses.noecho
          rc = Kernel.system(string)
          if not rc then
            @screen.mvaddstr(@termheight/4+1,1,"Error: exec \"#{string}\" failed with error code #{$?}")
            @screen.mvaddstr(@termheight-2,@termwidth/2-message.length/2,message)
          end
          if rc then
            @screen.mvaddstr(@termheight-2,@termwidth/2-message.length/2,message)
          end
          ch = Ncurses.getch()
          return
        when Ncurses::KEY_BACKSPACE
          string = string[0...([0, cursor_pos-1].max)] + string[cursor_pos..-1]
          cursor_pos = [0, cursor_pos-1].max
          window.mvaddstr(@termheight/4, 1+prompt.length+string.length, " ")
        when " "[0]..255
          if (cursor_pos < max_len)
            string[cursor_pos,0] = ch.chr
            cursor_pos += 1
          else
            Ncurses.beep
          end
      else
          Ncurses.beep
      end
    end
  end


  def slide_text(l)
    return if l == ""
    if @slidedir == "left" then
      xcount = l.length-1
      while xcount >= 0
        @screen.move(@cur_line,@indent)
        @screen.addstr(l[xcount..l.length-1])
        @screen.refresh()
        time_to_sleep = 1.to_f / 20
        Kernel.sleep(time_to_sleep)
        xcount -= 1
      end  
    elsif @slidedir == "right" then
      (@termwidth - @indent).times do |pos|
        @screen.move(@cur_line,@termwidth - pos - 1)
        @screen.clrtoeol()
        maxpos = (pos >= l.length-1) ? l.length-1 : pos
        @screen.addstr(l[0..pos])
        @screen.refresh()
        time_to_sleep = 1.to_f / 20
        Kernel.sleep(time_to_sleep)
      end # do
    elsif @slidedir == "top" then
      # ycount = @cur_line
      new_scr = @screen.dupwin
      1.upto(@cur_line) do |i|
        Ncurses.overwrite(new_scr,@screen) # overwrite @screen with new_scr
        @screen.move(i,@indent)
        @screen.addstr(l)
        @screen.refresh()
        Kernel.sleep(1.to_f / 10)
      end
    elsif @slidedir == "bottom" then
      new_scr = @screen.dupwin
      (@termheight-1).downto(@cur_line) do |i|
        Ncurses.overwrite(new_scr,@screen)
        @screen.move(i,@indent)
        @screen.addstr(l)
        @screen.refresh()
        Kernel.sleep(1.to_f / 10)
      end
    end
  end

  def draw_page(page)
    @output = false
    @shelloutput = false
    @slideoutput = false
    @with_border = false
    @cur_line = @voffset
    @screen.clear()
    draw_slidenum
    page.lines.each do |l|
     case l
        when /^--heading /
          @screen.move(@cur_line,@indent)
          text = l.sub(/^--heading /,"")
          x = (@termwidth - text.length)/2
          @screen.move(@cur_line,x)
          @screen.attron(Ncurses::A_BOLD)
          @screen.addstr(text)
          @screen.attroff(Ncurses::A_BOLD) # this is bad
          @cur_line += 1
        when /^--withborder/
          draw_border()
          @with_border = true
        when /^--color /
          text = l.sub(/^--color /,"")
          num = ColorMap.get_color_pair(text)
          Ncurses.attron(Ncurses.COLOR_PAIR(num))
          @current_color_pair = num
        when /^--center /
          @screen.move(@cur_line,@indent)
          if @output or @shelloutput then
            @screen.addstr("| ")
          end
          text = l.sub(/^--center /,"")
          x = (@termwidth - text.length)/2
          @screen.move(@cur_line,x)
          @screen.addstr(text)
          @cur_line += 1
        when /^--right /
          @screen.move(@cur_line,@indent)
          if @output or @shelloutput then
            @screen.addstr("| ")
          end
          text = l.sub(/^--right /,"")
          x = (@termwidth - text.length - 2)
          @screen.move(@cur_line,x)
          @screen.addstr(text)
          @cur_line += 1
        when /^--exec /
          cmdline = l.sub(/^--exec /,"")
          rc = Kernel.system(cmdline)
          if not rc then
            print_line("Error: exec \"#{cmdline}\" failed with error code #{$?}")
          end
        when /^---/
          while true do
            x = @screen.getch()
            case x
              when ' '[0]
                break
              when 'q'[0], 'Q'[0], 'j'[0], 'J'[0], 's'[0], 'S'[0], 'e'[0], 'E'[0], 'c'[0], 'C'[0]
                return x
            end # case
          end # while
          # @screen.refresh()
        when /^--beginoutput/
          @screen.move(@cur_line,@indent)
          @screen.addstr(".")
          ((@termwidth - @indent)/2).times { @screen.addstr("-") }
          @output = true
          @cur_line += 1
        when /^--beginshelloutput/
          @screen.move(@cur_line,@indent)
          @screen.addstr(".")
          ((@termwidth - @indent)/2).times { @screen.addstr("-") }
          @shelloutput = true
          @cur_line += 1
        when /^--endoutput/
          if @output then
            @screen.move(@cur_line,@indent)
            @screen.addstr("`")
            ((@termwidth - @indent)/2).times { @screen.addstr("-") }
            @output = false
            @cur_line += 1
          end
        when /^--endshelloutput/
          if @shelloutput then
            @screen.move(@cur_line,@indent)
            @screen.addstr("`")
            ((@termwidth - @indent)/2).times { @screen.addstr("-") }
            @shelloutput = false
            @cur_line += 1
          end
        when /^--sleep /
          time2sleep = l.sub(/^--sleep /,"")
          Kernel.sleep(time2sleep.to_i)
        when /^--boldon/
          @screen.attron(Ncurses::A_BOLD)
        when /^--boldoff/
          @screen.attroff(Ncurses::A_BOLD)
        when /^--revon/
          @screen.attron(Ncurses::A_REVERSE)
        when /^--revoff/
          @screen.attroff(Ncurses::A_REVERSE)
        when /^--ulon/
          @screen.attron(Ncurses::A_UNDERLINE)
        when /^--uloff/
          @screen.attroff(Ncurses::A_UNDERLINE)
        when /^--beginslideleft/
          @slideoutput = true
          @slidedir = "left"
        when /^--endslideleft/, /^--endslideright/, /^--endslidetop/, /^--endslidebottom/
          @slideoutput = false
        when /^--beginslideright/
          @slideoutput = true
          @slidedir = "right"
        when /^--beginslidetop/
          @slideoutput = true
          @slidedir = "top"
        when /^--beginslidebottom/
          @slideoutput = true
          @slidedir = "bottom"
        when /^--huge /
          figlet_text = l.sub(/^--huge /,"")
          output_width = @termwidth - @indent
          output_width -= 2 if output or shelloutput
          op = IO.popen("figlet -w #{output_width} -k \"#{figlet_text}\"","r")
          op.readlines.each do |line|
            print_line(line)
          end
          op.close
      else
        print_line(l)
      end
    end
    
	if @output or @shelloutput then # forgot --endoutput or --endshelloutput
      @screen.move(@cur_line,@indent)
      @screen.addstr("`")
      ((@termwidth - @indent)/2).times { @screen.addstr("-") }
    end
  end

  def print_line(line)
    @screen.move(@cur_line,@indent)
    if @output or @shelloutput then
      @screen.addstr("| ")
    end
    if @shelloutput and (line =~ /^\$/ or line=~ /^%/) then # allow sh and csh style prompts
      type_line(line)
    elsif @slideoutput then
      slide_text(line)
    else
      @screen.addstr(line)
    end
    @cur_line += 1
  end

  def show_helpscreen
    help_text = [ "tpp help", 
                  "",
                  "space bar ............................... display next entry within page",
                  "space bar, cursor-down, cursor-right .... display next page",
                  "b, cursor-up, cursor-left ............... display previous page",
                  "q, Q .................................... quit tpp",
                  "j, J .................................... jump directly to page",
                  "s, S .................................... jump to the first page",
                  "e, E .................................... jump to the last page",
                  "c, C .................................... start command line",
                  "? ....................................... this help screen" ]
    @screen.clear
    y = @voffset
    help_text.each do |line|
      @screen.move(y,@indent)
      @screen.addstr(line)
      y += 1
    end
    @screen.move(@termheight - 2, @indent)
    @screen.addstr("Press any key to return to slide")
    @screen.refresh()
    @screen.getch()
  end

  def run
    changed_page = true
    jumped_out = false
    x = ""
    while true do
      if changed_page then
        x = draw_page(@pages[@current_page])
        jump_out_chars = [ 'q'[0],'j'[0],'Q'[0],'J'[0],'e'[0],'E'[0],'s'[0],'S'[0],'c'[0],'C'[0],'?'[0] ]
        jumped_out = true if jump_out_chars.include?(x)
        # jumped_out = true if x == 'q'[0] or x == 'j'[0] or x == 'Q'[0] or x == 'J'[0] or x == 'e'[0] or x == 'E'[0] or x == 's'[0] or x == 'S'[0] or x == 'c' or x == 'C'[0]
        draw_slidenum # draw slidenum to bring cursor down
        @screen.refresh()
      end
      if not jumped_out then 
        draw_eop_marker
        draw_slidenum
        @screen.refresh()
        x = @screen.getch()
      end
      changed_page = false
      jumped_out = false
      case x
        when 'q'[0], 'Q'[0] # 'Q'uit
          return
        when 'r'[0], 'R'[0] # 'R'edraw slide
          changed_page = true
        when 'j'[0], 'J'[0] # 'J'ump to slide
          p = read_newpage
          if p >=0 and p < @number_pages then
            @current_page = p
          end
          changed_page = true
          draw_slidenum
        when '?'[0] # show a help screen explaining all important commands
          new_scr = @screen.dupwin
          show_helpscreen
          Ncurses.overwrite(new_scr,@screen)
          @screen.refresh()
          draw_slidenum
        when 'e'[0], 'E'[0] # jump to end
          @current_page=@number_pages-1
          changed_page = true
        when 's'[0], 'S'[0] # jump to start
          @current_page = 0
          changed_page = true
        when Ncurses::KEY_RIGHT, Ncurses::KEY_DOWN, ' '[0] # next slide
          if @current_page + 1 < @number_pages then
            @current_page += 1
            changed_page = true
          end
        when 'b'[0], 'B'[0], Ncurses::KEY_LEFT, Ncurses::KEY_UP # previous slide
          if @current_page > 0 then
            @current_page -= 1
            changed_page = true
          end
        when 'c'[0], 'C'[0] # commandprompt
          command_prompt()
          changed_page = true
        when Ncurses::KEY_RESIZE # WINCH signal (ugly!)
          set_sizes
      end # case
    end # while
  end

end

filename = nil
output_latex = false
latex_filename = nil
skip_next = false

ARGV.each_index do |i|
  if skip_next then
    skip_next = false
  else
    if ARGV[i] == "-l" or ARGV[i] == "--latex" then
      output_latex = true
      latex_filename = ARGV[i+1]
      skip_next = true
    elsif filename == nil then
      filename = ARGV[i]
    end
  end
end


if filename == nil then
  $stderr.puts "usage: #{$0} [-l <outputfile>] <file>"
  Kernel.exit(1)
end

parser = FileParser.new(filename)
parser.do_work

pages = parser.get_pages
bgcolor = parser.get_bgcolor

if output_latex then
  if latex_filename == nil then
    $stderr.puts "error: no filename supplied to -l"
    Kernel.exit(1)
  end
  gen = LatexGenerator.new(pages,parser.get_title,parser.get_author,parser.get_date)
  gen.generate_output(latex_filename)
else
  pager = Pager.new(pages,bgcolor)
  pager.run
  pager.close
end
