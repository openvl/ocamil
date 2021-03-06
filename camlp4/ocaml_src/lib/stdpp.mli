(* camlp4r *)
(***********************************************************************)
(*                                                                     *)
(*                             Camlp4                                  *)
(*                                                                     *)
(*        Daniel de Rauglaudre, projet Cristal, INRIA Rocquencourt     *)
(*                                                                     *)
(*  Copyright 2002 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

(* This file has been generated by program: do not edit! *)

(** Standard definitions. *)

exception Exc_located of (int * int) * exn;;
   (** [Exc_located loc e] is an encapsulation of the exception [e] with
       the input location [loc]. To be used in quotation expanders
       and in grammars to specify some input location for an error.
       Do not raise this exception directly: rather use the following
       function [raise_with_loc]. *)

val raise_with_loc : int * int -> exn -> 'a;;
   (** [raise_with_loc loc e], if [e] is already the exception [Exc_located],
       re-raise it, else raise the exception [Exc_located loc e]. *)

val line_of_loc : string -> int * int -> int * int * int;;
   (** [line_of_loc fname loc] reads the file [fname] up to the
       location [loc] and returns the line number and the characters
       location in the line *)

val loc_name : string ref;;
   (** Name of the location variable used in grammars and in the predefined
       quotations for OCaml syntax trees. Default: [loc] *)
