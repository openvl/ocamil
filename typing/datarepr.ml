(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: datarepr.ml,v 1.2 2006/02/05 01:47:11 montela Exp $ *)

(* Compute constructor and label descriptions from type declarations,
   determining their representation. *)

open Misc
open Asttypes
open Types

(* CAMILMOD: patched to cope with variant repr. modif. *)
let constructor_descrs ty_res cstrs =
  let num_consts = ref 0 and num_nonconsts = ref 0 in
  List.iter
    (function (name, []) -> incr num_consts
            | (name, _)  -> incr num_nonconsts)
    cstrs;
    let constants_only = if !num_nonconsts>0 then (num_nonconsts := !num_consts + !num_nonconsts;num_consts:=0;false) else true in
    let rec describe_constructors idx  = function
      [] -> []
    | (name, ty_args) :: rem ->
        let (tag, descr_rem) =
	  if constants_only then (Cstr_constant idx,
				  describe_constructors (idx+1)  rem)
	  else  (Cstr_block idx,
                 describe_constructors  (idx+1) rem) in
        let cstr =
          { cstr_res = ty_res;
            cstr_args = ty_args;
            cstr_arity = List.length ty_args;
            cstr_tag = tag;
            cstr_consts = !num_consts;
            cstr_nonconsts = !num_nonconsts } in
        (name, cstr) :: descr_rem in
  describe_constructors 0 cstrs

let exception_descr path_exc decl =
  { cstr_res = Predef.type_exn;
    cstr_args = decl;
    cstr_arity = List.length decl;
    cstr_tag = Cstr_exception path_exc;
    cstr_consts = -1;
    cstr_nonconsts = -1 }

let none = {desc = Ttuple []; level = -1; id = -1}
                                        (* Clearly ill-formed type *)
let dummy_label =
  { lbl_res = none; lbl_arg = none; lbl_mut = Immutable;
    lbl_pos = (-1); lbl_all = [||]; lbl_repres = Record_regular }

let label_descrs ty_res lbls repres =
  let all_labels = Array.create (List.length lbls) dummy_label in
  let rec describe_labels num = function
      [] -> []
    | (name, mut_flag, ty_arg) :: rest ->
        let lbl =
          { lbl_res = ty_res;
            lbl_arg = ty_arg;
            lbl_mut = mut_flag;
            lbl_pos = num;
            lbl_all = all_labels;
            lbl_repres = repres } in
        all_labels.(num) <- lbl;
        (name, lbl) :: describe_labels (num+1) rest in
  describe_labels 0 lbls

exception Constr_not_found

(* CAMILMOD: patched to cope with variant repr. modif. *)
let rec find_constr tag num_const num_nonconst = function
    [] ->
      raise Constr_not_found
  | (name, _ as cstr) :: rem ->
      if tag = Cstr_constant num_const || tag = Cstr_block num_nonconst
      then cstr
      else find_constr tag (num_const+1) (num_nonconst + 1) rem

let find_constr_by_tag tag cstrlist =
  find_constr tag 0 0 cstrlist
