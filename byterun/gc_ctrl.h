/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*             Damien Doligez, projet Para, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 1996 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../LICENSE.     */
/*                                                                     */
/***********************************************************************/

/* $Id: gc_ctrl.h,v 1.13 2002/05/28 16:57:31 doligez Exp $ */

#ifndef _gc_ctrl_
#define _gc_ctrl_

#include "misc.h"

extern double
     stat_minor_words,
     stat_promoted_words,
     stat_major_words;

extern long
     stat_minor_collections,
     stat_major_collections,
     stat_heap_size,
     stat_top_heap_size,
     stat_compactions,
     stat_heap_chunks;

void init_gc (unsigned long, unsigned long, unsigned long,
              unsigned long, unsigned long);


#ifdef DEBUG
void heap_check (void);
#endif

#endif /* _gc_ctrl_ */
