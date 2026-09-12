# PLAN.md

Design decisions for the Simple Adder MVP. See `AGENTS.md` for requirements and coding standards.

## Overview

A single-page app where the user enters two numbers, clicks "Add", and sees the sum. The frontend calls a backend REST API to perform the addition (per AGENTS.md requirement, not computed client-side).

## Architecture

```
simpleAdder/
  frontend/          Next.js app (UI)
  backend/           .NET Web API (addition endpoint)
  scripts/           start/stop scripts for PC and Linux
  docs/
    PLAN.md
```

## Tech stack and versions

- Frontend: Next.js 15 (App Router), React 19, TypeScript
- Frontend tests: Vitest (unit), Playwright (end-to-end)
- Backend: .NET 10 Web API (C#, minimal API style)
  - Note: AGENTS.md says ".NET 11"; .NET 11 has not been released as of today (2026-09-12) — .NET ships each November, so .NET 10 (Nov 2025) is current. Using .NET 10 now; revisit once .NET 11 is GA.
- Backend tests: xUnit
- Package managers: npm (frontend), dotnet CLI (backend)

## Backend design

- `POST /api/add`
  - Request body: `{ "a": number, "b": number }`
  - Response body: `{ "result": number }`
  - Validation: reject non-numeric input with 400 Bad Request
- `GET /health` - returns 200, used by the Playwright config to know when the backend is ready
- Minimal API (`Program.cs`), no controllers/services layers — the operation is a single line, extra layering would be over-engineering
- CORS enabled for the frontend's local origin during development
- Logging: built-in `ILogger`, configured to also write to a rolling log file (via `Microsoft.Extensions.Logging` file provider or Serilog file sink) under `backend/logs/`, for post-hoc investigation
- Unit tests (xUnit): cover the add logic and input validation
- Swagger/OpenAPI enabled in development for manual testing

## Frontend design

- Single page (`app/page.tsx`) with two number inputs and an "Add" button
- On click, POST to the backend `/api/add` endpoint, display the returned result or a validation error
- No client-side routing, no state management library — `useState` is sufficient
- Unit tests (Vitest): the add-request logic / result rendering, with the API call mocked
- End-to-end tests (Playwright): fill both inputs, click Add, assert the displayed sum, against the real backend. `playwright.config.ts` starts both the backend (`dotnet run`) and frontend (`npm run dev`) automatically via `webServer`

## Scripts

`scripts/` contains matched pairs for Windows and Linux:
- `start-backend.ps1` / `start-backend.sh`
- `start-frontend.ps1` / `start-frontend.sh`
- `stop-backend.ps1` / `stop-backend.sh`
- `stop-frontend.ps1` / `stop-frontend.sh`

Each start script launches its app in the background, writes its PID to `scripts/.run/*.pid`, and redirects output to `scripts/.run/*.log`. The matching stop script reads the PID file and kills the process (tree/group, so child processes like Turbopack workers also stop). The backend start script builds and runs the compiled DLL directly (not `dotnet run`) with `ASPNETCORE_ENVIRONMENT`/`ASPNETCORE_URLS` set explicitly, since `launchSettings.json` profiles only apply to `dotnet run`/IDEs, not to running the DLL directly.

## Non-goals

- No auth, no persistence/database, no multi-page UI
- No support for non-numeric or infinite operand ranges beyond standard IEEE 754 double handling
- No CI/CD pipeline setup (out of scope for MVP)
