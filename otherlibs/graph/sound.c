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

/* $Id: sound.c,v 1.8 2001/12/07 13:39:55 xleroy Exp $ */

#include "libgraph.h"

value gr_sound(value vfreq, value vdur)
{
  XKeyboardControl kbdcontrol;

  gr_check_open();
  kbdcontrol.bell_pitch = Int_val(vfreq);
  kbdcontrol.bell_duration = Int_val(vdur);
  XChangeKeyboardControl(grdisplay, KBBellPitch | KBBellDuration,
                         &kbdcontrol);
  XBell(grdisplay, 0);
  kbdcontrol.bell_pitch = -1;   /* restore default value */
  kbdcontrol.bell_duration = -1; /* restore default value */
  XChangeKeyboardControl(grdisplay, KBBellPitch | KBBellDuration,
                         &kbdcontrol);
  XFlush(grdisplay);
  return Val_unit;
}
