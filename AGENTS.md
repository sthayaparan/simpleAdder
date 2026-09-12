# The Simple Adder MVP web app

## Business Requirements

This project is building a Simple Adder App. Key features:
- user can enter two numbers in two textboxes and then cick the "Add" button: the result should be shown.

## Technical Decisions

- NextJS frontend; this should be in frontend directory
- Adding the two numbers should be implemented as REST API in the backend
- .NET 11 Web API backend; this should be in backend directory
- Start and Stop server scripts for PC, Linux in scripts/
- Add unit tests, end-to-end integration tests
- Use vtest and Playwright for frontend; xUnit/NUnit for backend
- Implement proper logging (writing to log file for investigation)


## Coding standards

1. Use latest versions of libraries and idiomatic approaches as of today
2. Keep it simple - NEVER over-engineer, ALWAYS simplify, NO unnecessary defensive programming. No extra features - focus on simplicity.
3. Be concise. Keep README minimal. IMPORTANT: no emojis ever
4. When hitting issues, always identify root cause before trying a fix. Do not guess. Prove with evidence, then fix the root cause.

## Working documentation

Update a PLAN.md file with the design decisions for this project in the docs/ directory.
