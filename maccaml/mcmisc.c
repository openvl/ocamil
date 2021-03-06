/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*             Damien Doligez, projet Para, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 1998 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../LICENSE.     */
/*                                                                     */
/***********************************************************************/

/* $Id: mcmisc.c,v 1.2 2001/12/07 13:39:47 xleroy Exp $ */

#include "main.h"

void LocalToGlobalRect (Rect *r)
{
  Point *p = (Point *) r;

  LocalToGlobal (&p[0]);
  LocalToGlobal (&p[1]);
}
