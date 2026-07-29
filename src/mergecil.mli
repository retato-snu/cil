(*

   Copyright (c) 2001-2002,
    George C. Necula    <necula@cs.berkeley.edu>
    Scott McPeak        <smcpeak@cs.berkeley.edu>
    Wes Weimer          <weimer@cs.berkeley.edu>
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:

   1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   3. The names of the contributors may not be used to endorse or promote
   products derived from this software without specific prior written
   permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
   OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 *)

(** Set this to true to ignore the merge conflicts *)
val ignore_merge_conflicts: bool ref

(** Try to merge definitions of inline functions. They can appear in multiple
   files and we would like them all to be the same. This can slow down the
   merger an order of magnitude !!! *)
val merge_inlines: bool ref

(** Out-of-band observation of source-level global merge decisions.  Recording
    never adds attributes to the CIL tree and is deliberately independent of
    the merge equality tests. *)
type provenance_item_kind =
  | Variable_declaration
  | Variable_definition
  | Function_definition

type merged_provenance_item = {
  provenance_merged_global_index : int;
  provenance_merged_chain_index : int;
  provenance_merged_initializer_index : int option;
  provenance_merged_name : string;
  provenance_merged_kind : provenance_item_kind;
  provenance_merged_location : Cil.location;
}

type provenance_outcome =
  | Merged_item of merged_provenance_item
  | Dropped_item

type provenance_row = {
  provenance_input_index : int;
  provenance_input_file : string;
  provenance_original_global_index : int;
  provenance_original_chain_index : int;
  provenance_original_initializer_index : int option;
  provenance_original_name : string;
  provenance_original_kind : provenance_item_kind;
  provenance_original_location : Cil.location;
  provenance_outcome : provenance_outcome;
}

(** The default is enabled.  Clients use this switch only for the
    observation-independence gate. *)
val provenance_recording : bool ref

(** Rows from the most recent [merge], in input-file/global order. *)
val provenance_rows : unit -> provenance_row list

(** Merge a number of CIL files *)
val merge: Cil.file list -> string -> Cil.file
