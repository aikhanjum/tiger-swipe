type cluster = { canonical : Email.t; duplicates : Email.t list }

let cluster ?threshold:_ ?k:_ _emails = failwith "TODO: Dedupe.cluster"
