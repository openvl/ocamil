# Top Makefile for mlTk

SUBDIRS=compiler support lib jpf frx tkanim examples_labltk \
	camltk labltk examples_camltk browser

all:
	cd support; $(MAKE)
	cd compiler; $(MAKE)
	cd labltk; $(MAKE) -f Makefile.gen
	cd labltk; $(MAKE)
	cd camltk; $(MAKE) -f Makefile.gen
	cd camltk; $(MAKE)
	cd lib; $(MAKE)
	cd jpf; $(MAKE)
	cd frx; $(MAKE)
	cd tkanim; $(MAKE)
	cd browser; $(MAKE)

allopt:
	cd support; $(MAKE) opt
	cd labltk; $(MAKE) -f Makefile.gen
	cd labltk; $(MAKE) opt
	cd camltk; $(MAKE) -f Makefile.gen
	cd camltk; $(MAKE) opt
	cd lib; $(MAKE) opt
	cd jpf; $(MAKE) opt
	cd frx; $(MAKE) opt
	cd tkanim; $(MAKE) opt

byte: all
opt: allopt

.PHONY: labltk camltk examples_labltk examples_camltk

labltk: Widgets.src
	compiler/tkcompiler -outdir labltk
	cd labltk; $(MAKE)

camltk: Widgets.src
	compiler/tkcompiler -camltk -outdir camltk
	cd camltk; $(MAKE)

examples: examples_labltk examples_camltk

examples_labltk:
	cd examples_labltk; $(MAKE) all

examples_camltk:
	cd examples_camltk; $(MAKE) all

install: 
	cd labltk; $(MAKE) install
	cd camltk; $(MAKE) install
	cd lib; $(MAKE) install
	cd support; $(MAKE) install
	cd compiler; $(MAKE) install
	cd jpf; $(MAKE) install
	cd frx; $(MAKE) install
	cd tkanim; $(MAKE) install
	cd browser; $(MAKE) install

installopt:
	cd labltk; $(MAKE) installopt
	cd camltk; $(MAKE) installopt
	cd lib; $(MAKE) installopt
	cd jpf; $(MAKE) installopt
	cd frx; $(MAKE) installopt
	cd tkanim; $(MAKE) installopt

partialclean clean: 
	for d in $(SUBDIRS); do \
	    cd $$d; $(MAKE) -f Makefile clean; cd ..; \
	done

depend:
