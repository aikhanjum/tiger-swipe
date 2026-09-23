<p align="center">
  <img src="vibeathon_tigerswipe_logo.png" alt="TigerSwipe logo" width="160" />
</p>

<h1 align="center">TigerSwipe</h1>

<p align="center">
  <strong>Swipe through your inbox. Right for yes, left for no.</strong><br />
  Every club and event buried in your Princeton email, turned into a deck of cards.
</p>

<p align="center">
  <a href="https://vibeathon-g93k.vercel.app"><strong>▶ Try it live</strong></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/%F0%9F%8F%86%20People's%20Choice-Princeton%20Vibe--a--Thon%202025-FF8F00?style=for-the-badge" alt="People's Choice, Princeton Vibe-a-Thon 2025" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=white" />
  <img src="https://img.shields.io/badge/TypeScript-5-3178C6?logo=typescript&logoColor=white" />
  <img src="https://img.shields.io/badge/Express-4-000000?logo=express&logoColor=white" />
  <img src="https://img.shields.io/badge/Claude-classification-D97757?logo=anthropic&logoColor=white" />
  <img src="https://img.shields.io/badge/Clerk-Google%20OAuth-6C47FF?logo=clerk&logoColor=white" />
</p>

---

## 🏆 People's Choice winner

TigerSwipe won **People's Choice at the Princeton Vibe-a-Thon** (fall 2025), built in a single day by Princeton freshmen.

## The problem

Princeton students get dozens of listserv emails a day. Club recruitment, speaker events, info sessions, practices, socials. The good ones get lost under everything else, and by the time you find them the application is closed.

## What TigerSwipe does

1. **Sign in with Google.** TigerSwipe reads your inbox (read-only) through Clerk OAuth.
2. **Claude sorts the noise.** Every email is classified into a club or an event, tagged by type (workshop, speaker, competition, social...) and by vibe (chill, high-energy, tight-knit, skill-building...).
3. **Swipe.** Opportunities show up as a Tinder-style deck. Filter by events or clubs, swipe left to skip.
4. **Swipe right to commit.** The application opens instantly, and accepted events land on your Google Calendar through an MCP calendar integration.

## How it works

```
Gmail (OAuth, read-only)
        │
        ▼
Express API ──► Claude classifier ──► typed EventCards (cached)
        │                                   │
        │                                   ▼
        │                        React swipe deck (Framer Motion)
        │                                   │ swipe right
        ▼                                   ▼
Google Calendar MCP  ◄──────────  POST /api/cards/:id/apply
```

- **Classification:** `apps/server/src/services/claudeClassifier.ts` prompts Claude for strict JSON, validates every field against allowed enums, and caches results so the same email is never classified twice.
- **Three inbox modes:** per-user Gmail via Clerk OAuth (default), a single server-side inbox via refresh token, or bundled mock data for demos.
- **Calendar:** `apps/server/src/services/googleCalendarMcp.ts` inserts accepted events through a Google Calendar MCP server.

## Stack

| Layer    | Tech                                                            |
| -------- | --------------------------------------------------------------- |
| Frontend | Vite, React 18, TypeScript, Tailwind, Framer Motion, `react-tinder-card` |
| Backend  | Express, Zod, `googleapis`                                      |
| AI       | Claude (Anthropic Messages API)                                 |
| Auth     | Clerk with Google OAuth (Gmail read-only scope)                 |
| Tooling  | pnpm workspaces, Vitest, ESLint, Prettier, Vercel               |

## Run it locally

```bash
pnpm install
cp .env.example .env      # fill in the three required keys
pnpm dev:server           # API on http://localhost:4000
pnpm dev:web              # app on http://localhost:5173
```

Only three variables are required: `CLERK_SECRET_KEY`, `VITE_CLERK_PUBLISHABLE_KEY`, and `CLAUDE_API_KEY`. Without Gmail credentials the app falls back to mock emails, so you can try the full swipe flow with no Google setup. Every variable is documented in [`.env.example`](.env.example).

For real Gmail access, follow [docs/setup/clerk-google-oauth.md](docs/setup/clerk-google-oauth.md).

### API

| Method | Route                     | What it does                                        |
| ------ | ------------------------- | --------------------------------------------------- |
| GET    | `/api/cards?type=events\|clubs` | Classified cards for the swipe deck           |
| POST   | `/api/cards/:id/apply`    | Records an application and adds the event to Calendar |

### Tests

```bash
pnpm --filter server test   # classifier + calendar MCP client
pnpm --filter web test      # swipe deck smoke test
pnpm -r lint
```

## Repo layout

```
apps/
  server/   Express API, Gmail ingestion, Claude classifier, Calendar MCP
  web/      React swipe deck, landing page, club application page
data/       mock emails for demo mode
docs/
  setup/    Clerk, Google OAuth, Gmail, and testing guides
  notes/    build notes from the hackathon
```

## What's next

- Persist swipe history so decks survive refreshes
- One-tap applications through a browser extension ([notes](docs/notes/extension-notes.md))
- Smarter ranking: learn from your swipes which clubs and events to show first

## Team

Built at the Princeton Vibe-a-Thon by [Aikhan Jumashukurov](https://github.com/aikhanjum) and [Patrick Fu](https://github.com/trickfu).
