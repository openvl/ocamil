(*************************************************************************)
(*                                                                       *)
(*                Objective Caml LablTk library                          *)
(*                                                                       *)
(*            Jacques Garrigue, Kyoto University RIMS                    *)
(*                                                                       *)
(*   Copyright 2000 Institut National de Recherche en Informatique et    *)
(*   en Automatique and Kyoto University.  All rights reserved.          *)
(*   This file is distributed under the terms of the GNU Library         *)
(*   General Public License, with the special exception on linking       *)
(*   described in file ../../../LICENSE.                                 *)
(*                                                                       *)
(*************************************************************************)

(* $Id: dummyUnix.mli,v 1.3 2001/12/07 13:39:55 xleroy Exp $ *)

module Mutex : sig
  type t
  external create : unit -> t = "%ignore"
  external lock : t -> unit = "%ignore"
  external unlock : t -> unit = "%ignore"
end

module Thread : sig
  type t
  external create : ('a -> 'b) -> 'a -> t = "caml_input"
end
