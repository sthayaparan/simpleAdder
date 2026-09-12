# simpleAdder

Simple calculator: add two numbers. See `AGENTS.md` for requirements and `docs/PLAN.md` for design decisions.

## Structure

- `frontend/` - Next.js UI
- `backend/SimpleAdder.Api/` - .NET Web API (`POST /api/add`)
- `backend/SimpleAdder.Api.Tests/` - xUnit tests
- `scripts/` - start/stop scripts for both apps (PowerShell and bash)

## Run

Windows:

```
scripts\start-backend.ps1
scripts\start-frontend.ps1
```

Linux:

```
scripts/start-backend.sh
scripts/start-frontend.sh
```

Frontend: http://localhost:3000. Backend: http://localhost:5253. Stop with the matching `stop-*` script.

Copy `frontend/.env.local.example` to `frontend/.env.local` to override the backend URL the frontend calls.

## Test

Backend:

```
cd backend
dotnet test
```

Frontend unit tests:

```
cd frontend
npm test
```

Frontend end-to-end tests (starts both backend and frontend automatically):

```
cd frontend
npm run test:e2e
```
