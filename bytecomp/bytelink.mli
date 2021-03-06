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

(* $Id: bytelink.mli,v 1.11 2002/06/11 14:15:11 xleroy Exp $ *)

(* Link .cmo files and produce a bytecode executable. *)

val link: string list -> string -> unit

val check_consistency: string -> Emitcode.compilation_unit -> unit

val extract_crc_interfaces: unit -> (string * Digest.t) list

type error =
    File_not_found of string
  | Not_an_object_file of string
  | Symbol_error of string * Symtable.error
  | Inconsistent_import of string * string * string
  | Custom_runtime
  | File_exists of string
  | Cannot_open_dll of string

exception Error of error

open Format

val report_error: formatter -> error -> unit
