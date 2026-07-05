---
paths:
  - '.github/**'
---

# CI rules

- Pin every GitHub Action to a full commit SHA with a version comment (`uses: owner/action@<sha> # vX.Y.Z`) — tags are mutable.
- Least privilege: keep top-level `permissions: contents: read`; grant extra scopes per job, never globally.
- Every job sets `timeout-minutes`.
- Every checkout sets `persist-credentials: false`.
- Workflow changes must keep zizmor (`.github/workflows/zizmor.yml`) green.
