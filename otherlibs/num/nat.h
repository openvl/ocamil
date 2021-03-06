/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 1999 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../../LICENSE.  */
/*                                                                     */
/***********************************************************************/

/* $Id: nat.h,v 1.5 2001/12/07 13:40:15 xleroy Exp $ */

/* Nats are represented as unstructured blocks with tag Custom_tag. */

#define Bignum_val(nat) ((BigNum) Data_custom_val(nat))

