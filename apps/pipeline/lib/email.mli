(** A listserv email, as the Express server sends it (camelCase JSON). *)
type t = {
  id : string;
  from : string;
  subject : string;
  body : string;
  received_at : string;
  links : string list;
}

val t_of_yojson : Yojson.Safe.t -> t
val yojson_of_t : t -> Yojson.Safe.t
