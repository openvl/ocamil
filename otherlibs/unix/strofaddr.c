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

/* $Id: strofaddr.c,v 1.8 2001/12/07 13:40:36 xleroy Exp $ */

#include <mlvalues.h>
#include <alloc.h>
#include "unixsupport.h"

#ifdef HAS_SOCKETS

#include "socketaddr.h"

CAMLprim value unix_string_of_inet_addr(value a)
{
  struct in_addr address;
  address.s_addr = GET_INET_ADDR(a);
  return copy_string(inet_ntoa(address));
}

#else

CAMLprim value unix_string_of_inet_addr(value a)
{ invalid_argument("string_of_inet_addr not implemented"); }

#endif
