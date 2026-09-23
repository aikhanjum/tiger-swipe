(** Group emails that announce the same thing to different listservs. *)

type cluster = {
  canonical : Email.t;  (** the earliest-received email in the group *)
  duplicates : Email.t list;  (** the rest, in input order *)
}

val cluster : ?threshold:float -> ?k:int -> Email.t list -> cluster list
(** Two emails belong together when the Jaccard similarity of their
    subject+body shingles is >= [threshold] (default 0.6, shingle size
    [k] default 3). Grouping is transitive: if A~B and B~C then A, B, C
    share a cluster even if A and C are not directly similar.
    Clusters come back ordered by their canonical email's position in
    the input. Every input email appears in exactly one cluster. *)
