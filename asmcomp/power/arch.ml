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

(* $Id: arch.ml,v 1.8 2002/07/22 16:37:53 doligez Exp $ *)

(* Specific operations for the PowerPC processor *)

open Misc
open Format

type specific_operation =
    Imultaddf                           (* multiply and add *)
  | Imultsubf                           (* multiply and subtract *)
  | Ialloc_far of int                   (* allocation in large functions *)

(* Addressing modes *)

type addressing_mode =
    Ibased of string * int              (* symbol + displ *)
  | Iindexed of int                     (* reg + displ *)
  | Iindexed2                           (* reg + reg *)

(* Sizes, endianness *)

let big_endian = true

let size_addr = 4
let size_int = 4
let size_float = 8

(* Operations on addressing modes *)

let identity_addressing = Iindexed 0

let offset_addressing addr delta =
  match addr with
    Ibased(s, n) -> Ibased(s, n + delta)
  | Iindexed n -> Iindexed(n + delta)
  | Iindexed2 -> Misc.fatal_error "Arch_power.offset_addressing"

let num_args_addressing = function
    Ibased(s, n) -> 0
  | Iindexed n -> 1
  | Iindexed2 -> 2

(* Printing operations and addressing modes *)

let print_addressing printreg addr ppf arg =
  match addr with
  | Ibased(s, n) ->
      let idx = if n <> 0 then Printf.sprintf " + %i" n else "" in
      fprintf ppf "\"%s\"%s" s idx
  | Iindexed n ->
      let idx = if n <> 0 then Printf.sprintf " + %i" n else "" in
      fprintf ppf "%a%s" printreg arg.(0) idx
  | Iindexed2 ->
      fprintf ppf "%a + %a" printreg arg.(0) printreg arg.(1)

let print_specific_operation printreg op ppf arg =
  match op with
  | Imultaddf ->
      fprintf ppf "%a *f %a +f %a"
        printreg arg.(0) printreg arg.(1) printreg arg.(2)
  | Imultsubf ->
      fprintf ppf "%a *f %a -f %a"
        printreg arg.(0) printreg arg.(1) printreg arg.(2)
  | Ialloc_far n ->
      fprintf ppf "alloc_far %d" n

(* Distinguish between the PowerPC and the Power/RS6000 submodels *)

let powerpc =
  match Config.model with
  | "ppc" -> true
  | "rs6000" -> false
  | _ -> Misc.fatal_error "wrong $(MODEL)"

(* Distinguish between the PowerOpen (AIX, MacOS) TOC-based,
   relative-addressing model and the SVR4 (Solaris, MkLinux, Rhapsody)
   absolute-addressing model. *)

let toc =
  match Config.system with
  | "aix" -> true
  | "elf" -> false
  | "rhapsody" -> false
  | _ -> Misc.fatal_error "wrong $(SYSTEM)"
