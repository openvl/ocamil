# $Id: Makefile,v 1.7 2002/07/22 16:38:07 doligez Exp $

include ../config/Makefile

INCLUDES=-I ../camlp4 -I ../boot
OCAMLCFLAGS=-warn-error A $(INCLUDES)
SRC=../etc/pa_o.ml ../etc/pa_op.ml
D=o
COMP_OPT=-strict_parsing
COMP_OPT=-e "Grammar.Entry.obj Pcaml.interf" -e "Grammar.Entry.obj Pcaml.implem" -e "Grammar.Entry.obj Pcaml.top_phrase" -e "Grammar.Entry.obj Pcaml.use_file"

all: out

out: camlp4$D.fast
opt: camlp4$D.fast.opt

camlp4$D.fast: pa_$D_fast.cmo
	rm -f camlp4$D.fast
	cd ../camlp4; $(MAKE) CAMLP4=../compile/camlp4$D.fast CAMLP4M="../compile/pa_$D_fast.cmo ../meta/pr_dump.cmo"

camlp4$D.fast.opt: pa_$D_fast.cmx
	rm -f camlp4$D.fast.opt
	cd ../camlp4; $(MAKE) optp4 CAMLP4OPT=../compile/camlp4$D.fast.opt CAMLP4M="../compile/pa_$D_fast.cmx ../meta/pr_dump.cmx"

pa_$D_fast.ml: comp_head.ml $D_fast.ml comp_trail.ml
	cat $(SRC) | sed -e "s/Plexer.gmake ()/P.lexer/" -e "/EXTEND/,/END/d" -e "/Grammar.Entry.of_parser/d" -e "/Grammar.Entry.gcreate/d" | cat comp_head.ml - $D_fast.ml comp_trail.ml > pa_$D_fast.ml

$D_fast.ml: compile.cmo $(SRC)
	OTOP=$(OTOP) EXE=$(EXE) ./compile.sh $(COMP_OPT) $(SRC) > $D_fast.ml

install:
	if test -f camlp4o.fast.opt; then cp camlp4o.fast.opt $(BINDIR)/camlp4o.opt; fi

clean::
	rm -f *.cm* *.pp[io] *.o *.bak .*.bak *.out *.opt
	rm -f *.fast tmp.* pa_*_fast.ml *_fast.ml

depend:
	cp .depend .depend.bak
	> .depend
	@for i in *.mli *.ml; do \
	  ../tools/apply.sh pr_depend.cmo -- $(INCLUDES) $$i >> .depend || : ; \
	done

include .depend
