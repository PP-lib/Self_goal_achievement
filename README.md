# Self_goal_achievement
management my goals

## Open in GitHub Codespaces

1. Open this repository in GitHub and create a new Codespace.
2. The container auto-starts a Node web server on port 8080.
3. Open the forwarded port URL (or browser preview).
4. Access the app with `index.html` (redirects to `radar_chart.html`).

## JSON Management in GitHub

- The app reads initial state from `scores.json` via `/api/state`.
- Every browser edit is saved back to `scores.json` via `/api/state`.
- This keeps JSON managed inside the repository in Codespaces.

## Files

- `radar_chart.html`: Main application
- `scores.json`: Saved data template
- `index.html`: Entry point for web hosting/preview
- `server.js`: Static hosting + JSON API (`GET/POST /api/state`)
