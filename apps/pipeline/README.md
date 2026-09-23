# TigerSwipe pipeline (OCaml)

The email pipeline for TigerSwipe: ingest listserv email, collapse the same
announcement sent to many listservs into one card, then hand clusters to the
classifier. Written in OCaml 5 with Dream, tested with Jane Street's `ppx_expect`.

## Setup

```bash
opam switch tigerswipe && eval $(opam env)
cd apps/pipeline
opam install . --deps-only -y   # first time only
dune build
dune test          # expect tests; failures show a diff
dune promote       # accept a new expected output (only when it's right!)
dune exec bin/main.exe   # http://localhost:4100/health
```

## Roadmap

1. `Text.normalize`, `Text.shingles`, `Similarity.jaccard`
2. `Dedupe.cluster` (union-find over pairwise Jaccard)
3. `POST /dedupe` route in `bin/main.ml`, called by the Express server
4. MinHash + LSH so dedupe scales past O(n²) pairwise comparisons
5. Gmail push notifications (Pub/Sub webhook) straight into this service
