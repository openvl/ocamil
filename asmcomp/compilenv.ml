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

(* $Id: compilenv.ml,v 1.17 2006/07/08 05:11:38 montela Exp $ *)

(* Compilation environments for compilation units *)


open Config
open Misc
open Ctypedlambda

type error =
    Not_a_unit_info of string
  | Corrupted_unit_info of string
  | Illegal_renaming of string * string


exception Error of error

(* Each .o file has a matching .cmx file that provides the following infos
   on the compilation unit:
     - list of other units imported, with CRCs of their .cmx files
     - approximation of the structure implemented
       (includes descriptions of known functions: arity and direct entry
        points)
     - list of currying functions and application functions needed
   The .cmx file contains these infos (as an externed record) plus a CRC
   of these infos

For COM+, I add :
    - name of the class for the unit
    - ----------------- for imported units
*)

type unit_infos =
  { mutable ui_name: string;                    (* Name of unit implemented *)
    mutable ui_defines: string list;      (* Unit and sub-units implemented *)
    mutable ui_imports_cmi: (string * Digest.t) list; (* Interfaces imported *)
    mutable ui_imports_cmx: (string * Il.typeref * Digest.t) list; (* Infos imported *)
    mutable ui_approx: value_approximation;     (* Approx of the structure *)
    mutable ui_curry_fun: int list;             (* Currying functions needed *)
    mutable ui_apply_fun: int list;             (* Apply functions needed *)
    mutable ui_force_link: bool;                (* Always linked *)
    mutable ui_class: Il.typeref;              (* IL class name *)
    mutable ui_compilationmode: Clflags.compmode;            
(*    mutable ui_nb_const_ctr: int; *)
  }

let nothing = fun (oc:out_channel) -> ()
let appending_tocmx_fun = ref nothing

let set_appending_tocmx_fun f = 
  appending_tocmx_fun := f


(* Each .a library has a matching .cmxa file that provides the following
   infos on the library: *)

type library_infos =
  { lib_units: (unit_infos * Digest.t) list;  (* List of unit infos w/ CRCs *)
    lib_ccobjs: string list;            (* C object files needed *)
    lib_ccopts: string list }           (* Extra opts to C compiler *)

let global_approx_table =
  (Hashtbl.create 17 : (string, value_approximation) Hashtbl.t)

let current_unit =
  { ui_name = "";
    ui_defines = [];
    ui_imports_cmi = [];
    ui_imports_cmx = [];
    ui_approx = Value_unknown;
    ui_curry_fun = [];
    ui_apply_fun = [];
    ui_force_link = false;
    ui_class = Ilbuild.type_ref "" "" ;
    ui_compilationmode = !Clflags.compilation_mode;
(*    ui_nb_const_ctr=0 *)
}

(* AJOUT RAF pour ce qui echappait au link *)
let current_unit_addit = ref ([] : string list)

let reset name =
  Hashtbl.clear global_approx_table;
  current_unit.ui_name <- name;
  current_unit.ui_defines <- [name];
  current_unit.ui_imports_cmi <- [];
  current_unit.ui_imports_cmx <- [];
  current_unit.ui_curry_fun <- [];
  current_unit.ui_apply_fun <- [];
  current_unit.ui_force_link <- false;
  current_unit.ui_class <- Ilbuild.type_ref "" "";
  current_unit.ui_compilationmode <- !Clflags.compilation_mode;
(*  current_unit.ui_nb_const_ctr <- 0; *)
  (* AJOUT RAF *)
  current_unit_addit := []


let current_unit_name () =
  current_unit.ui_name

let _ = 
  Utils.current_unit_name := current_unit_name


let read_unit_info filename =
  let ic = open_in_bin filename in
  try
    let buffer = String.create (String.length cmx_magic_number) in
    really_input ic buffer 0 (String.length cmx_magic_number);
    if buffer <> cmx_magic_number then begin
      close_in ic;
      raise(Error(Not_a_unit_info filename))
    end;
    let ui = (input_value ic : unit_infos) in
    let crc = Digest.input ic in
    close_in ic;
    (ui, crc)
  with End_of_file | Failure _ ->
    close_in ic;
    raise(Error(Corrupted_unit_info(filename)))


let skip_header_unit_info ic filename = (* pour un fichier deja verifie *)
  try
    let buffer = String.create (String.length cmx_magic_number) in
      really_input ic buffer 0 (String.length cmx_magic_number);
      ignore (input_value ic : unit_infos);
      ignore (Digest.input ic)
  with End_of_file | Failure _ ->
    close_in ic;
    raise(Error(Corrupted_unit_info(filename)))


(* Return the approximation of a global identifier *)

let cmx_not_found_crc =
  "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let global_approx global_ident =
  let modname = Ident.name global_ident in
  if modname = current_unit.ui_name then
    current_unit.ui_approx
  else begin
    try
      Hashtbl.find global_approx_table modname
    with Not_found ->
      let (approx, cname, crc) =
        try
          let filename =
            find_in_path_uncap !load_path (modname ^ ".cmx") in
          let (ui, crc) = read_unit_info filename in
          if ui.ui_name <> modname then
            raise(Error(Illegal_renaming(ui.ui_name, filename)));
          (ui.ui_approx, ui.ui_class, crc)
        with Not_found ->
          (Value_unknown, Ilbuild.type_ref "" "" , cmx_not_found_crc) in
      current_unit.ui_imports_cmx <-
        (modname, cname, crc) :: current_unit.ui_imports_cmx;
      Hashtbl.add global_approx_table modname approx;
      approx
  end

(* Register the approximation of the module being compiled *)

let set_global_approx approx =
  current_unit.ui_approx <- approx

(* Record that a currying function or application function is needed *)

let need_curry_fun n =
  if not (List.mem n current_unit.ui_curry_fun) then
    current_unit.ui_curry_fun <- n :: current_unit.ui_curry_fun

let need_apply_fun n =
  if not (List.mem n current_unit.ui_apply_fun) then
    current_unit.ui_apply_fun <- n :: current_unit.ui_apply_fun

(* Write the description of the current unit *)

let write_unit_info info filename =
  (*MOD*)
  current_unit.ui_imports_cmi <- Env.imported_units();
  let oc = open_out_bin filename in
  output_string oc cmx_magic_number;
    (*MOD*)
    current_unit.ui_compilationmode <- !Clflags.compilation_mode;
    output_value oc current_unit;
  flush oc;
  let crc = Digest.file filename in
  Digest.output oc crc;
      !appending_tocmx_fun oc;
	  appending_tocmx_fun := nothing;
  close_out oc

let save_unit_info filename =
  current_unit.ui_imports_cmi <- Env.imported_units();
  write_unit_info current_unit filename;
  

(* Error report *)

open Format

let report_error ppf = function
  | Not_a_unit_info filename ->
      fprintf ppf "%s@ is not a compilation unit description." filename
  | Corrupted_unit_info filename ->
      fprintf ppf "Corrupted compilation unit description@ %s" filename
  | Illegal_renaming(modname, filename) ->
      fprintf ppf "%s@ contains the description for unit@ %s" filename modname

let get_current_unit () = current_unit


let init_toplevel () = 
  current_unit.ui_imports_cmx <- ("Toploop",Ilbuild.type_ref "Toploop" "Top","") ::current_unit.ui_imports_cmx 
      
      
