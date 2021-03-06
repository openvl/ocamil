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

/* $Id: image.h,v 1.7 2001/12/07 13:39:54 xleroy Exp $ */

struct grimage {
  int width, height;            /* Dimensions of the image */
  Pixmap data;                  /* Pixels */
  Pixmap mask;                  /* Mask for transparent points, or None */
};

#define Width_im(i) (((struct grimage *)Data_custom_val(i))->width)
#define Height_im(i) (((struct grimage *)Data_custom_val(i))->height)
#define Data_im(i) (((struct grimage *)Data_custom_val(i))->data)
#define Mask_im(i) (((struct grimage *)Data_custom_val(i))->mask)

#define Transparent (-1)

value gr_new_image(int w, int h);
