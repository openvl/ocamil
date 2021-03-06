#########################################################################
#                                                                       #
#                            Objective Caml                             #
#                                                                       #
#            Xavier Leroy, projet Cristal, INRIA Rocquencourt           #
#                                                                       #
#   Copyright 1999 Institut National de Recherche en Informatique et    #
#   en Automatique.  All rights reserved.  This file is distributed     #
#   under the terms of the GNU Library General Public License, with     #
#   the special exception on linking described in file ../../LICENSE.   #
#                                                                       #
#########################################################################

# $Id: Makefile,v 1.50 2002/07/08 07:30:08 garrigue Exp $

include ../../config/Makefile

CC=$(BYTECC)
CFLAGS=-I../../byterun -O $(BYTECCCOMPOPTS) $(SHAREDCCCOMPOPTS) -g
CAMLC=../../ocamlcomp.sh -I ../unix
MKLIB=../../boot/ocamlrun ../../tools/ocamlmklib
COMPFLAGS=-warn-error A

C_OBJS=scheduler.o

CAML_OBJS=thread.cmo mutex.cmo condition.cmo event.cmo threadUnix.cmo

LIB=../../stdlib

LIB_OBJS=pervasives.cmo \
  $(LIB)/array.cmo $(LIB)/list.cmo $(LIB)/char.cmo $(LIB)/string.cmo \
  $(LIB)/sys.cmo $(LIB)/hashtbl.cmo $(LIB)/sort.cmo \
  marshal.cmo $(LIB)/obj.cmo \
  $(LIB)/lexing.cmo $(LIB)/parsing.cmo \
  $(LIB)/set.cmo $(LIB)/map.cmo $(LIB)/stack.cmo $(LIB)/queue.cmo \
  $(LIB)/stream.cmo $(LIB)/buffer.cmo \
  $(LIB)/printf.cmo $(LIB)/format.cmo \
  $(LIB)/scanf.cmo $(LIB)/arg.cmo \
  $(LIB)/printexc.cmo $(LIB)/gc.cmo $(LIB)/digest.cmo $(LIB)/random.cmo \
  $(LIB)/camlinternalOO.cmo \
  $(LIB)/oo.cmo $(LIB)/genlex.cmo $(LIB)/callback.cmo $(LIB)/weak.cmo \
  $(LIB)/lazy.cmo $(LIB)/filename.cmo $(LIB)/int32.cmo $(LIB)/int64.cmo \
  $(LIB)/nativeint.cmo \
  $(LIB)/arrayLabels.cmo $(LIB)/listLabels.cmo $(LIB)/stringLabels.cmo \
  $(LIB)/stdLabels.cmo $(LIB)/moreLabels.cmo

UNIXLIB=../unix

UNIXLIB_OBJS=unix.cmo $(UNIXLIB)/unixLabels.cmo

all: libthreads.a threads.cma stdlib.cma unix.cma

allopt:

libthreads.a: $(C_OBJS)
	$(MKLIB) -o threads $(C_OBJS)

threads.cma: $(CAML_OBJS)
	$(MKLIB) -ocamlc '$(CAMLC)' -o threads $(CAML_OBJS)

stdlib.cma: $(LIB_OBJS)
	$(CAMLC) -a -o stdlib.cma $(LIB_OBJS)

unix.cma: $(UNIXLIB_OBJS)
	$(MKLIB) -ocamlc '$(CAMLC)' -o unix -linkall $(UNIXLIB_OBJS)

pervasives.cmo: pervasives.mli pervasives.cmi pervasives.ml
	$(CAMLC) ${COMPFLAGS} -nopervasives -c pervasives.ml

pervasives.mli: $(LIB)/pervasives.mli
	ln -s $(LIB)/pervasives.mli pervasives.mli

pervasives.cmi: $(LIB)/pervasives.cmi
	ln -s $(LIB)/pervasives.cmi pervasives.cmi

marshal.cmo: marshal.mli marshal.cmi marshal.ml
	$(CAMLC) ${COMPFLAGS} -c marshal.ml

marshal.mli: $(LIB)/marshal.mli
	ln -s $(LIB)/marshal.mli marshal.mli

marshal.cmi: $(LIB)/marshal.cmi
	ln -s $(LIB)/marshal.cmi marshal.cmi

unix.cmo: unix.mli unix.cmi unix.ml
	$(CAMLC) ${COMPFLAGS} -c unix.ml

unix.mli: $(UNIXLIB)/unix.mli
	ln -s $(UNIXLIB)/unix.mli unix.mli

unix.cmi: $(UNIXLIB)/unix.cmi
	ln -s $(UNIXLIB)/unix.cmi unix.cmi

partialclean:
	rm -f *.cm*

clean: partialclean
	rm -f libthreads.a dllthreads.so *.o
	rm -f pervasives.mli marshal.mli unix.mli

install:
	if test -f dllthreads.so; then cp dllthreads.so $(STUBLIBDIR)/dllthreads.so; fi
	cp libthreads.a $(LIBDIR)/libthreads.a
	cd $(LIBDIR); $(RANLIB) libthreads.a
	if test -d $(LIBDIR)/threads; then : ; else mkdir $(LIBDIR)/threads; fi
	cp thread.cmi mutex.cmi condition.cmi event.cmi threadUnix.cmi threads.cma stdlib.cma unix.cma $(LIBDIR)/threads
	cp thread.mli mutex.mli condition.mli event.mli threadUnix.mli $(LIBDIR)

installopt:

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.mli.cmi:
	$(CAMLC) -c $(COMPFLAGS) $<

.ml.cmo:
	$(CAMLC) -c $(COMPFLAGS) $<

.ml.cmx:
	$(CAMLOPT) -c $(COMPFLAGS) $<

depend:
	gcc -MM $(CFLAGS) *.c > .depend
	../../boot/ocamlrun ../../tools/ocamldep *.mli *.ml >> .depend

include .depend
