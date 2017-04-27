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

/* $Id: getpeername.c,v 1.9 2001/12/07 13:40:29 xleroy Exp $ */

#include <mlvalues.h>
#include "unixsupport.h"

#ifdef HAS_SOCKETS

#include "socketaddr.h"

CAMLprim value unix_getpeername(value sock)
{
  int retcode;
  union sock_addr_union addr;
  socklen_param_type addr_len;

  addr_len = sizeof(sock_addr);
  retcode = getpeername(Int_val(sock), &addr.s_gen, &addr_len);
  if (retcode == -1) uerror("getpeername", Nothing);
  return alloc_sockaddr(&addr, addr_len);
}

#else

CAMLprim value unix_getpeername(value sock)
{ invalid_argument("getpeername not implemented"); }
  
#endif