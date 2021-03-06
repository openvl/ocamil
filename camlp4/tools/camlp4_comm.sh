#!/bin/sh
# $Id: camlp4_comm.sh,v 1.6 2002/07/23 14:11:49 doligez Exp $

ARGS1=
FILE=
while test "" != "$1"; do
        case $1 in
        *.ml*) FILE=$1;;
        *) ARGS1="$ARGS1 $1";;
        esac
        shift
done

head -1 $FILE >/dev/null || exit 1

set - `head -1 $FILE`
if test "$2" = "camlp4r" -o "$2" = "camlp4"; then
        COMM="ocamlrun$EXE ../boot/$2$EXE -nolib -I ../boot"
        if test "`basename $OTOP`" != "ocaml_stuff"; then
            COMM="$OTOP/boot/$COMM"
        fi
        shift; shift
        ARGS2=`echo $* | sed -e "s/[()*]//g"`
#        ARGS1="$ARGS1 -verbose"
        echo $COMM $ARGS2 $ARGS1 $FILE
        $COMM $ARGS2 $ARGS1 $FILE
else
        if test "`basename $FILE .mli`.mli" = "$FILE"; then
                OFILE=`basename $FILE .mli`.ppi
        else
                OFILE=`basename $FILE .ml`.ppo
        fi
        echo cp $FILE $OFILE
        cp $FILE $OFILE
fi
