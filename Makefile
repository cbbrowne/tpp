# tpp Makefile by Nico Golde <binclock@ngolde.de>
# Latest Change: Sam Jul 31 00:58:01 CEST 2004 
#################################################

BIN = tpp  
INSPATH = /usr/local/bin/
DOCPATH = /usr/local/share/doc/tpp

install :

	mkdir $(DOCPATH)	
	install -m644 CHANGES COPYING README $(DOCPATH)	
	install tpp.rb $(INSPATH)$(BIN)		

uninstall : 
	rm -f $(INSPATH)$(BIN)
	rm -rf $(DOCPATH)
