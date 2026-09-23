open Ppx_yojson_conv_lib.Yojson_conv.Primitives

(* Mirrors NormalizedEmail in apps/server/src/email/types.ts. *)
type t = {
  id : string;
  from : string;
  subject : string;
  body : string;
  received_at : string; [@key "receivedAt"]
  links : string list;
}
[@@deriving yojson]
