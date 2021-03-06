/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 1996 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../../LICENSE.  */
/*                                                                     */
/***********************************************************************/

/* $Id: pipe.c,v 1.9 2001/12/07 13:40:32 xleroy Exp $ */

#include <mlvalues.h>
#include <alloc.h>
#include "unixsupport.h"

CAMLprim value unix_pipe(void)
{
  int fd[2];
  value res;
  if (pipe(fd) == -1) uerror("pipe", Nothing);
  res = alloc_small(2, 0);
  Field(res, 0) = Val_int(fd[0]);
  Field(res, 1) = Val_int(fd[1]);
  return res;
}
