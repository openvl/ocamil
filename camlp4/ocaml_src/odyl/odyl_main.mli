(* camlp4r *)
(* This file has been generated by program: do not edit! *)

exception Error of string * string;;

val nolib : bool ref;;
val initialized : bool ref;;
val path : string list ref;;
val loadfile : string -> unit;;
val directory : string -> unit;;

val go : (unit -> unit) ref;;
val name : string ref;;
