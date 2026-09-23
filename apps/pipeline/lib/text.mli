(** Text normalization and shingling for near-duplicate detection. *)

module String_set : Set.S with type elt = string

val normalize : string -> string
(** Lowercase, replace every non-alphanumeric character with a space,
    and collapse runs of whitespace into one space, trimmed.
    [normalize "  Hello,   WORLD!! "] is ["hello world"]. *)

val shingles : k:int -> string -> String_set.t
(** The set of all runs of [k] consecutive words in [normalize s].
    If the text has fewer than [k] words, the whole normalized text is
    the single shingle. Empty text gives the empty set.
    [shingles ~k:2 "a b c"] is [{"a b"; "b c"}]. *)
