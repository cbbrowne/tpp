#!/usr/bin/ruby

require "ncurses"

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


class FileParser

  def initialize(filename)
    @filename = filename
    @pages = [ nil ]
  end

  def do_work
    f = File.open(@filename)

    if not f then
      $stderr.puts "Couldn't open #{@filename}."
      Kernel.exit(1)
    end

    cur_page = nil

    title = ""
    author = ""
    date = ""
    abstract = []

    number_pages = 0

    f.each_line do |line|
      line.chomp!
      case line
        when /^--title / # store title
          title = line.sub(/^--title /,"")
        when /^--author / # store author
          author = line.sub(/^--author /,"")
        when /^--date / # store date
          date = line.sub(/^--date /,"")
          if date == "today" then
            date = Time.now.strftime("%b %d %Y")
          end
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

    front_page = Page.new("#{title}")
    fp_lines = ["--heading #{title}", 
                "",
                "--center #{author}",
                "--center #{date}",
                "" ]
    abstract.each { |al| fp_lines << al }
    front_page.set_lines(fp_lines)
    @pages[0] = front_page
  end

  def get_pages
    @pages
  end

end


class Pager

  def initialize(pages)
    @pages = pages
    Ncurses.initscr
    Ncurses.cbreak # unbuffered input
    Ncurses.noecho # turn off input echoing
    Ncurses.stdscr.intrflush(false)
    Ncurses.stdscr.keypad(true)
    @current_page = 0
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
    @screen.addstr("slide #{@current_page+1}/#{@number_pages}")
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

  def draw_page(page)
    output = false
    shelloutput = false
    cur_line = @voffset
    @screen.clear()
    draw_slidenum
    page.lines.each do |l|
      case l
        when /^--heading /
          @screen.move(cur_line,@indent)
          text = l.sub(/^--heading /,"")
          x = (@termwidth - text.length)/2
          @screen.move(cur_line,x)
          @screen.attron(Ncurses::A_BOLD)
          @screen.addstr(text)
          @screen.attroff(Ncurses::A_BOLD) # this is bad
          cur_line += 1
        when /^--center /
          @screen.move(cur_line,@indent)
          if output or shelloutput then
            @screen.addstr("| ")
          end
          text = l.sub(/^--center /,"")
          x = (@termwidth - text.length)/2
          @screen.move(cur_line,x)
          @screen.addstr(text)
          cur_line += 1
        when /^--right /
          @screen.move(cur_line,@indent)
          if output or shelloutput then
            @screen.addstr("| ")
          end
          text = l.sub(/^--right /,"")
          x = (@termwidth - text.length - 2)
          @screen.move(cur_line,x)
          @screen.addstr(text)
          cur_line += 1
        when /^---/
          @screen.refresh()
          while true do
            x = @screen.getch()
            case x
              when ' '[0]
                break
              when 'q'[0], 'Q'[0], 'j'[0], 'J'[0]
                return x
            end # case
          end # while
        when /^--beginoutput/
          @screen.move(cur_line,@indent)
          @screen.addstr(".")
          ((@termwidth - @indent)/2).times { @screen.addstr("-") }
          output = true
          cur_line += 1
        when /^--beginshelloutput/
          @screen.move(cur_line,@indent)
          @screen.addstr(".")
          ((@termwidth - @indent)/2).times { @screen.addstr("-") }
          shelloutput = true
          cur_line += 1
        when /^--endoutput/
          @screen.move(cur_line,@indent)
          @screen.addstr("`")
          ((@termwidth - @indent)/2).times { @screen.addstr("-") }
          output = false
          cur_line += 1
        when /^--endshelloutput/
          @screen.move(cur_line,@indent)
          @screen.addstr("`")
          ((@termwidth - @indent)/2).times { @screen.addstr("-") }
          shelloutput = false
          cur_line += 1
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
        when /^--huge /
          figlet_text = l.sub(/^--huge /,"")
          output_width = @termwidth - @indent
          op = IO.popen("figlet -w #{output_width} -k \"#{figlet_text}\"","r")
          op.readlines.each do |line|
            @screen.move(cur_line,@indent)
            if output or shelloutput then
              @screen.addstr("| ")
            end
            if shelloutput and line =~ /^\$/ then
              type_line(line)
            else
              @screen.addstr(line)
            end
            cur_line += 1
          end
          op.close
      else
        @screen.move(cur_line,@indent)
        if output or shelloutput then
          @screen.addstr("| ")
        end
        if shelloutput and l =~ /^\$/ then
          type_line(l)
        else
          @screen.addstr(l)
        end
        cur_line += 1
      end
    end
    if output or shelloutput then # forgot --endoutput or --endshelloutput
      @screen.move(cur_line,@indent)
      @screen.addstr("`")
      ((@termwidth - @indent)/2).times { @screen.addstr("-") }
    end
  end

  def run
    changed_page = true
    jumped_out = false
    x = ""
    while true do
      if changed_page then
        x = draw_page(@pages[@current_page])
        jumped_out = true if x == 'q'[0] or x == 'j'[0] or x == 'Q'[0] or x == 'J'[0]
        draw_slidenum # draw slidenum to bring cursor down
        @screen.refresh()
      end
      x = @screen.getch() if not jumped_out
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
        when Ncurses::KEY_RESIZE # WINCH signal (ugly!)
          set_sizes
      end # case
    end # while
  end

end


filename = ARGV[0]
if filename == nil then
  $stderr.puts "usage: $0 <file>"
  Kernel.exit(1)
end

parser = FileParser.new(filename)
parser.do_work

pages = parser.get_pages

pager = Pager.new(pages)

pager.run

pager.close
