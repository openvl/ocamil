/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 1996 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the Q Public License version 1.0.               */
/*                                                                     */
/***********************************************************************/

/* Based on public-domain code from Berkeley Yacc */

/* $Id: skeleton.c,v 1.11 2001/11/05 13:34:42 xleroy Exp $ */

#include "defs.h"

char *header[] =
{
  "open Parsing",
  0
};

char *define_tables[] =
{
  "let yytables =",
  "  { actions=yyact;",
  "    transl_const=yytransl_const;",
  "    transl_block=yytransl_block;",
  "    lhs=yylhs;",
  "    len=yylen;",
  "    defred=yydefred;",
  "    dgoto=yydgoto;",
  "    sindex=yysindex;",
  "    rindex=yyrindex;",
  "    gindex=yygindex;",
  "    tablesize=yytablesize;",
  "    table=yytable;",
  "    check=yycheck;",
  "    error_function=parse_error;",
  "    names_const=yynames_const;",
  "    names_block=yynames_block }",
  0
};

void write_section(char **section)
{
    register int i;
    register FILE *fp;

    fp = code_file;
    for (i = 0; section[i]; ++i)
    {
        ++outline;
        fprintf(fp, "%s\n", section[i]);
    }
}
