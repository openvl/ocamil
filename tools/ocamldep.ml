(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1999 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: ocamldep.ml,v 1.29 2002/06/07 13:30:00 xleroy Exp $ *)

open Format
open Location
open Longident
open Parsetree


(* Print the dependencies *)

let load_path = ref [""]

let native_only = ref false
let force_slash = ref false

let find_file name =
  let filename = Misc.find_in_path_uncap !load_path name in
  if !force_slash then begin
    let filename = String.copy filename in
    for i = 0 to String.length filename - 1 do
      if filename.[i] = '\\' then filename.[i] <- '/'
    done;
    filename
  end else
    filename

let find_dependency modname (byt_deps, opt_deps) =
  try
    let filename = find_file (modname ^ ".mli") in
    let basename = Filename.chop_suffix filename ".mli" in
    ((basename ^ ".cmi") :: byt_deps,
     (if Sys.file_exists (basename ^ ".ml")
      then basename ^ ".cmx"
      else basename ^ ".cmi") :: opt_deps)
  with Not_found ->
  try
    let filename = find_file (modname ^ ".ml") in
    let basename = Filename.chop_suffix filename ".ml" in
    ((basename ^ (if !native_only then ".cmx" else ".cmo")) :: byt_deps,
     (basename ^ ".cmx") :: opt_deps)
  with Not_found ->
    (byt_deps, opt_deps)

let (depends_on, escaped_eol) =
  match Sys.os_type with
  | "Unix" | "Win32" | "Cygwin" -> (": ", "\\\n    ")
  | "MacOS" -> ("\196 ", "\182\n    ")
  | _ -> assert false

let print_dependencies target_file deps =
  match deps with
    [] -> ()
  | _ ->
    print_string target_file; print_string depends_on;
    let rec print_items pos = function
      [] -> print_string "\n"
    | dep :: rem ->
        if pos + String.length dep <= 77 then begin
          print_string dep; print_string " ";
          print_items (pos + String.length dep + 1) rem
        end else begin
          print_string escaped_eol; print_string dep; print_string " ";
          print_items (String.length dep + 5) rem
        end in
    print_items (String.length target_file + 2) deps

(* Optionally preprocess a source file *)

let preprocessor = ref None

let preprocess sourcefile =
  match !preprocessor with
    None -> sourcefile
  | Some pp ->
      flush stdout;
      let tmpfile = Filename.temp_file "camlpp" "" in
      let comm = Printf.sprintf "%s %s > %s" pp sourcefile tmpfile in
      if Sys.command comm <> 0 then begin
        Misc.remove_file tmpfile;
        Printf.eprintf "Preprocessing error\n";
        exit 2
      end;
      tmpfile

let remove_preprocessed inputfile =
  match !preprocessor with
    None -> ()
  | Some _ -> Misc.remove_file inputfile

(* Parse a file or get a dumped syntax tree in it *)

exception Outdated_version

let is_ast_file ic ast_magic =
  try
    let buffer = String.create (String.length ast_magic) in
    really_input ic buffer 0 (String.length ast_magic);
    if buffer = ast_magic then true
    else if String.sub buffer 0 9 = String.sub ast_magic 0 9 then
      raise Outdated_version
    else false
  with
    Outdated_version ->
      failwith "Ocaml and preprocessor have incompatible versions"
  | _ -> false

let parse_use_file ic =
  if is_ast_file ic Config.ast_impl_magic_number then
    let source_file = input_value ic in
    [Ptop_def (input_value ic : Parsetree.structure)]
  else begin
    seek_in ic 0;
    let lb = Lexing.from_channel ic in
    Parse.use_file lb
  end

let parse_interface ic =
  if is_ast_file ic Config.ast_intf_magic_number then
    let source_file = input_value ic in
    (input_value ic : Parsetree.signature)
  else begin
    seek_in ic 0;
    let lb = Lexing.from_channel ic in
    Parse.interface lb
  end

(* Process one file *)

let error_occurred = ref false

let file_dependencies source_file =
  Location.input_name := source_file;
  if Sys.file_exists source_file then begin
    try
      Depend.free_structure_names := Depend.StringSet.empty;
      let input_file = preprocess source_file in
      let ic = open_in_bin input_file in
      try
        if Filename.check_suffix source_file ".ml" then begin
          let ast = parse_use_file ic in
          Depend.add_use_file Depend.StringSet.empty ast;
          let basename = Filename.chop_suffix source_file ".ml" in
          let init_deps =
            if Sys.file_exists (basename ^ ".mli")
            then let cmi_name = basename ^ ".cmi" in ([cmi_name], [cmi_name])
            else ([], []) in
          let (byt_deps, opt_deps) =
            Depend.StringSet.fold find_dependency !Depend.free_structure_names init_deps in
          print_dependencies (basename ^ ".cmo") byt_deps;
          print_dependencies (basename ^ ".cmx") opt_deps
        end else
        if Filename.check_suffix source_file ".mli" then begin
          let ast = parse_interface ic in
          Depend.add_signature Depend.StringSet.empty ast;
          let basename = Filename.chop_suffix source_file ".mli" in
          let (byt_deps, opt_deps) =
            Depend.StringSet.fold find_dependency !Depend.free_structure_names ([], []) in
          print_dependencies (basename ^ ".cmi") byt_deps
        end else
          ();
        close_in ic; remove_preprocessed input_file
      with x ->
        close_in ic; remove_preprocessed input_file;
        raise x
    with x ->
      let report_err = function
      | Lexer.Error(err, start, stop) ->
          fprintf Format.err_formatter "@[%a%a@]@."
          Location.print {loc_start = start; loc_end = stop; loc_ghost = false}
          Lexer.report_error err
      | Syntaxerr.Error err ->
          fprintf Format.err_formatter "@[%a@]@."
          Syntaxerr.report_error err
      | Sys_error msg ->
          fprintf Format.err_formatter "@[I/O error:@ %s@]@." msg
      | x -> raise x in
      error_occurred := true;
      report_err x
  end

(* Entry point *)

let usage = "Usage: ocamldep [-I <dir>] [-native] <files>"

let _ =
  Clflags.classic := false;
  Arg.parse [
     "-I", Arg.String(fun dir -> load_path := !load_path @ [dir]),
       "<dir>  Add <dir> to the list of include directories";
     "-native", Arg.Set native_only,
       "  Generate dependencies for a pure native-code project \
       (no .cmo files)";
     "-slash", Arg.Set force_slash,
       "  (for Windows) Use forward slash / instead of backslash \\ in file paths";
     "-pp", Arg.String(fun s -> preprocessor := Some s),
       "<command>  Pipe sources through preprocessor <command>"
    ] file_dependencies usage;
  exit (if !error_occurred then 2 else 0)
