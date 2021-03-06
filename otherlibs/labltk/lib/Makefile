include ../support/Makefile.common

all: $(LIBNAME).cma $(LIBNAME)top$(EXE) $(LIBNAME)

opt: $(LIBNAME).cmxa

clean: 
	rm -f $(LIBNAME)top$(EXE) $(LIBNAME) *.cm* *.a

superclean:
	- if test -f tk.cmo; then \
	  echo We have changes... Now lib directory has no .cmo files; \
	  rm -f *.cm* *.o; \
	fi

include ../labltk/modules
LABLTKOBJS=tk.cmo $(WIDGETOBJS)

include ../camltk/modules
CAMLTKOBJS=cTk.cmo $(CWIDGETOBJS) labltk.cmo camltk.cmo

SUPPORT=../support/support.cmo ../support/rawwidget.cmo \
	../support/widget.cmo ../support/protocol.cmo \
        ../support/textvariable.cmo ../support/timer.cmo \
        ../support/fileevent.cmo ../support/camltkwrap.cmo

TKOBJS=$(SUPPORT) $(LABLTKOBJS) $(CAMLTKOBJS)

TOPDEPS = $(TOPDIR)/toplevel/toplevellib.cma $(TOPDIR)/toplevel/topmain.cmo

$(LIBNAME).cma: $(SUPPORT)
	$(MAKE) superclean
	cd ../labltk; $(MAKE)
	cd ../camltk; $(MAKE)
	$(MKLIB) -ocamlc '$(CAMLC)' -o $(LIBNAME) -oc $(LIBNAME) \
          -I ../labltk -I ../camltk $(TKOBJS) \
          $(TK_LINK)

$(LIBNAME).cmxa: $(SUPPORT:.cmo=.cmx)
	$(MAKE) superclean
	cd ../labltk; $(MAKE) opt
	cd ../camltk; $(MAKE) opt
	$(MKLIB) -ocamlopt '$(CAMLOPT)' -o $(LIBNAME) -oc $(LIBNAME) \
          -I ../labltk -I ../camltk $(TKOBJS:.cmo=.cmx) \
          $(TK_LINK)

$(LIBNAME)top$(EXE) : $(TOPDEPS) $(LIBNAME).cma ../support/lib$(LIBNAME).a
	$(CAMLC) -verbose -linkall -o $(LIBNAME)top$(EXE) -I ../support \
	       -I $(TOPDIR)/toplevel toplevellib.cma \
	       -I ../labltk -I ../camltk $(LIBNAME).cma \
	       -I $(OTHERS)/unix unix.cma \
	       -I $(OTHERS)/str str.cma \
	       topstart.cmo

$(LIBNAME): Makefile $(TOPDIR)/config/Makefile
	@echo Generate $@
	@echo "#!/bin/sh" > $@
	@echo 'exec $(INSTALLDIR)/$(LIBNAME)top$(EXE) -I $(INSTALLDIR) $$*' >> $@

install:
	if test -d $(INSTALLDIR); then : ; else mkdir $(INSTALLDIR); fi
	cp $(LIBNAME).cma $(LIBNAME)top$(EXE) $(INSTALLDIR)
	chmod 644 $(INSTALLDIR)/$(LIBNAME).cma
	chmod 755 $(INSTALLDIR)/$(LIBNAME)top$(EXE)
	@if test -d $(BINDIR); then : ; else mkdir $(BINDIR); fi
	cp $(LIBNAME) $(BINDIR)
	chmod 755 $(BINDIR)/$(LIBNAME)

installopt:
	@if test -d $(INSTALLDIR); then : ; else mkdir $(INSTALLDIR); fi
	cp $(LIBNAME).cmxa $(LIBNAME).a $(INSTALLDIR)
	cd $(INSTALLDIR); $(RANLIB) $(LIBNAME).a
	chmod 644 $(INSTALLDIR)/$(LIBNAME).cmxa
	chmod 644 $(INSTALLDIR)/$(LIBNAME).a
