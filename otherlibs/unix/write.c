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

/* $Id: write.c,v 1.13 2001/12/07 13:40:39 xleroy Exp $ */

#include <errno.h>
#include <string.h>
#include <mlvalues.h>
#include <memory.h>
#include <signals.h>
#include "unixsupport.h"

#ifndef EAGAIN
#define EAGAIN (-1)
#endif
#ifndef EWOULDBLOCK
#define EWOULDBLOCK (-1)
#endif

CAMLprim value unix_write(value fd, value buf, value vofs, value vlen)
{
  long ofs, len, written;
  int numbytes, ret;
  char iobuf[UNIX_BUFFER_SIZE];

  Begin_root (buf);
    ofs = Long_val(vofs);
    len = Long_val(vlen);
    written = 0;
    while (len > 0) {
      numbytes = len > UNIX_BUFFER_SIZE ? UNIX_BUFFER_SIZE : len;
      memmove (iobuf, &Byte(buf, ofs), numbytes);
      enter_blocking_section();
      ret = write(Int_val(fd), iobuf, numbytes);
      leave_blocking_section();
      if (ret == -1) {
        if ((errno == EAGAIN || errno == EWOULDBLOCK) && written > 0) break;
        uerror("write", Nothing);
      }
      written += ret;
      ofs += ret;
      len -= ret;
    }
  End_roots();
  return Val_long(written);
}
