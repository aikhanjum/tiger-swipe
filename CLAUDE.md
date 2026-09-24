# TigerSwipe

Swipe-to-decide app for Princeton listserv email. People's Choice, Princeton Vibe-a-Thon 2025.
Monorepo: `apps/web` (React/Vite PWA-to-be), `apps/server` (Express, auth, cards),
`apps/pipeline` (OCaml 5 + Dream: ingestion, dedupe, later Gmail push).
Live: https://tiger-swipe.vercel.app (frontend), https://tigerswipe-server.onrender.com (API).

## Rules for apps/pipeline (OCaml) — agreed with Aikhan, enforce them

The pipeline exists so Aikhan learns OCaml deeply enough to defend it in a
Jane Street interview. So:
- **Aikhan writes every `.ml` implementation.** Claude writes `.mli` interfaces,
  `dune`/opam plumbing, and expect tests, and explains concepts. No function
  bodies from Claude. Hints are questions or pseudocode, never OCaml.
- Tests first and red. `dune test` output is the source of truth; ask for it
  before believing anything works. Never `dune promote` a wrong output.
- Expected test outputs must be verified independently before committing them.
- Idiomatic OCaml over clever OCaml: pattern matching, `List`/`Set`/`Map`,
  immutability first. Explain Jane Street style when relevant.

## Rules for apps/web and apps/server (TypeScript)

Normal collaboration; Claude can write code here. The app must keep building:
`npx pnpm@9 build`, `npx pnpm@9 -r test`. pnpm 9 is pinned; keep pnpm-lock.yaml committed.

## Plan

1. Pipeline dedupe (Text, Similarity, Dedupe) — in progress
2. PWA + design pass on the swipe deck
3. POST /dedupe wired into Express; Postgres for cards + swipes
4. MinHash/LSH, Gmail push via Pub/Sub, swipe-learned ranking

Priority note: Aikhan's KHAN interpreter (~/dev/khan-lang) parser is the
higher-priority project for recruiting; TigerSwipe is the weekend project.
