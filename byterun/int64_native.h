/***********************************************************************/
/*                                                                     */
/*                           Objective Caml                            */
/*                                                                     */
/*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         */
/*                                                                     */
/*  Copyright 2002 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../LICENSE.     */
/*                                                                     */
/***********************************************************************/

/* $Id: int64_native.h,v 1.1 2002/05/25 08:32:53 xleroy Exp $ */

/* Wrapper macros around native 64-bit integer arithmetic,
   so that it has the same interface as the software emulation
   provided in int64_emul.h */

#define I64_compare(x,y) ((x) == (y) ? 0 : (x) < (y) ? -1 : 1)
#define I64_neg(x) (-(x))
#define I64_add(x,y) ((x) + (y))
#define I64_sub(x,y) ((x) - (y))
#define I64_mul(x,y) ((x) * (y))
#define I64_is_zero(x) ((x) == 0)
#define I64_is_negative(x) ((x) < 0)
#define I64_div(x,y) ((x) / (y))
#define I64_mod(x,y) ((x) % (y))
#define I64_udivmod(x,y,quo,rem) \
  (*(rem) = (uint64)(x) % (uint64)(y), \
   *(quo) = (uint64)(x) / (uint64)(y))
#define I64_and(x,y) ((x) & (y))
#define I64_or(x,y) ((x) | (y))
#define I64_xor(x,y) ((x) ^ (y))
#define I64_lsl(x,y) ((x) << (y))
#define I64_asr(x,y) ((x) >> (y))
#define I64_lsr(x,y) ((uint64)(x) >> (y))
#define I64_to_long(x) ((long) (x))
#define I64_of_long(x) ((int64) (x))
#define I64_to_int32(x) ((int32) (x))
#define I64_of_int32(x) ((int64) (x))
#define I64_to_double(x) ((double)(x))
#define I64_of_double(x) ((int64)(x))

