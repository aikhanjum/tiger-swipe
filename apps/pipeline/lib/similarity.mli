(** Set similarity. *)

val jaccard : Text.String_set.t -> Text.String_set.t -> float
(** |A ∩ B| / |A ∪ B|, in [0, 1]. Two empty sets are defined as 0.0
    (nothing in common to measure). *)
