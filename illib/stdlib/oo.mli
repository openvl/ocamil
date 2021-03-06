(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*         Jerome Vouillon, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../LICENSE.     *)
(*                                                                     *)
(***********************************************************************)

(* $Id: oo.mli,v 1.27 2002/06/26 09:12:49 xleroy Exp $ *)

(** Operations on objects *)

val copy : (< .. > as 'a) -> 'a
(** [Oo.copy o] returns a copy of object [o], that is a fresh
   object with the same methods and instance variables as [o]  *)

external id : < .. > -> int = "%field1"
(** Return an integer identifying this object, unique for
    the current execution of the program. *)

(**/**)
(** For internal use (CamlIDL) *)
val new_method : string -> CamlinternalOO.label
val public_method_label : string -> CamlinternalOO.label
