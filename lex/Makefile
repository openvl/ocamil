#########################################################################
#                                                                       #
#                            Objective Caml                             #
#                                                                       #
#            Xavier Leroy, projet Cristal, INRIA Rocquencourt           #
#                                                                       #
#   Copyright 1999 Institut National de Recherche en Informatique et    #
#   en Automatique.  All rights reserved.  This file is distributed     #
#   under the terms of the Q Public License version 1.0.                #
#                                                                       #
#########################################################################

# $Id: Makefile,v 1.13 2002/07/23 14:11:49 doligez Exp $

# The lexer generator

CAMLC=../boot/ocamlrun ../boot/ocamlc -I ../boot
CAMLOPT=../boot/ocamlrun ../ocamlopt -I ../stdlib
COMPFLAGS=-warn-error A
LINKFLAGS=
CAMLYACC=../boot/ocamlyacc
YACCFLAGS=-v
CAMLLEX=../boot/ocamlrun ../boot/ocamllex
CAMLDEP=../boot/ocamlrun ../tools/ocamldep
DEPFLAGS=

OBJS=parser.cmo lexer.cmo lexgen.cmo compact.cmo output.cmo main.cmo

all: ocamllex syntax.cmo
allopt: ocamllex.opt

ocamllex: $(OBJS)
	$(CAMLC) $(LINKFLAGS) -o ocamllex $(OBJS)

ocamllex.opt: $(OBJS:.cmo=.cmx)
	$(CAMLOPT) -o ocamllex.opt $(OBJS:.cmo=.cmx)

clean::
	rm -f ocamllex ocamllex.opt
	rm -f *.cmo *.cmi *.cmx *.o
	rm -f parser.output

parser.ml parser.mli: parser.mly
	$(CAMLYACC) $(YACCFLAGS) parser.mly

clean::
	rm -f parser.ml parser.mli

beforedepend:: parser.ml parser.mli

lexer.ml: lexer.mll
	$(CAMLLEX) lexer.mll

clean::
	rm -f lexer.ml

beforedepend:: lexer.ml

.SUFFIXES:
.SUFFIXES: .ml .cmo .mli .cmi .cmx

.ml.cmo:
	$(CAMLC) -c $(COMPFLAGS) $<

.mli.cmi:
	$(CAMLC) -c $(COMPFLAGS) $<

.ml.cmx:
	$(CAMLOPT) -c $(COMPFLAGS) $<

depend: beforedepend
	$(CAMLDEP) *.mli *.ml > .depend

include .depend
