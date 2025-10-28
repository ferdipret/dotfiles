# Documentation Hosting Options

[← Back to Index](index.md)

This note captures the approaches we discussed for serving the Markdown docs on Netlify, keeping the Neovim repo public, and optionally isolating the site scaffolding.

---

## 1. Single Repo Strategy (Fastest Path)

- **Layout**: Keep `docs/` where it is. Add a `site/` folder with your static site tooling (Docusaurus, Astro, VitePress, Eleventy, etc.).
- **Config**: Point the generator at the sibling `../docs` directory so Markdown stays in one place.
- **Build**: Run `npm --prefix site run build` (or equivalent) to emit HTML into `site/build` or `site/dist`. Netlify’s `netlify.toml` uses that publish folder.
- **Pros**: Zero syncing overhead; docs edits in the Neovim repo show up immediately. Easy local dev (`npm --prefix site run start`).
- **Cons**: Site scaffolding remains public alongside the config.

---

## 2. Private Site Repo + Public Docs

Keep a private repo for the site and pull the public docs into it automatically. Two ways to sync:

### 2.1 Git Submodule (Simplest)
- Add the public repo as a submodule inside the private repo (`git submodule add ... docs-source`).
- Configure the generator to read from `docs-source/docs`.
- Netlify needs “Git submodules” enabled; every build runs `git submodule update --init --remote`.
- **Pros**: No CI scripting, Netlify handles the sync.
- **Cons**: Submodules can be finicky locally; you must commit updated submodule pointers when testing.

### 2.2 Sync Workflow (More Control & CI Practice)
- **Automation flow**:
  1. Public-repo GitHub Action runs on `push` to `main`.
  2. Action checks out both repos (public & private) using a Deploy Key or PAT stored in repo secrets.
  3. Copy `docs/` into the private repo workspace and commit with a bot identity (`docs-sync-bot@users.noreply.github.com`).
  4. Push to the private repo’s default branch.
  5. Trigger a Netlify build hook via `curl https://api.netlify.com/build_hooks/<hook-id>`.
- **Starter workflow** (`.github/workflows/sync-docs.yml` in the public repo):
  ```yaml
  name: Sync Docs to Site Repo

  on:
    push:
      branches: [main]

  jobs:
    sync:
      runs-on: ubuntu-latest
      steps:
        - name: Checkout public repo
          uses: actions/checkout@v4
        - name: Checkout private site repo
          uses: actions/checkout@v4
          with:
            repository: your-org/private-docs-site
            path: site-repo
            token: ${{ secrets.PRIVATE_SITE_TOKEN }}
        - name: Copy docs
          run: |
            rm -rf site-repo/docs
            mkdir -p site-repo/docs
            cp -a docs/. site-repo/docs/
        - name: Commit changes
          run: |
            cd site-repo
            if git diff --quiet --exit-code; then
              echo "No changes to sync."
              exit 0
            fi
            git config user.name "Docs Sync Bot"
            git config user.email "docs-sync-bot@users.noreply.github.com"
            git add docs
            git commit -m "chore: sync docs from public repo"
            git push
        - name: Trigger Netlify build
          if: ${{ success() }}
          run: curl -X POST -d {} ${{ secrets.NETLIFY_BUILD_HOOK }}
  ```
- **Pros**: No submodule headaches; you gain CI/CD experience and have full control over when builds run.
- **Cons**: Requires managing secrets (PAT or Deploy Key) and handling merge conflicts if both repos modify docs simultaneously.

---

## Tooling Suggestions

- **Node ecosystem** (recommended): Docusaurus, Astro, VitePress, Eleventy. All let you wrap Markdown in custom navigation/themes while keeping content in Markdown.
- **Elixir ecosystem**: Phoenix + NimblePublisher + Earmark/Makeup, if you prefer LiveView/HEEx layouts. Deploy via Netlify (static export) or an alternative host (Fly.io, Render).
- Theme control comes from the site tool’s config—swap CSS variables, Tailwind themes, or React/Vue components without touching Markdown.

---

## Netlify Integration Notes

- Add `netlify.toml` with the build command and publish directory.
- Commit lockfiles (`package-lock.json`, `pnpm-lock.yaml`, or `mix.lock`) so Netlify installs exact versions.
- For private repo deployments, use Netlify build hooks to trigger rebuilds when the docs sync.
- `netlify dev` (CLI) mirrors production locally to catch link or build issues before pushing.

---

## Decision Summary

| Option | When to choose | Maintenance burden |
|--------|----------------|--------------------|
| Single Repo | You’re fine with public site scaffolding, want the simplest workflow | Low |
| Submodule | You want private scaffolding but minimal CI scripting | Medium (submodule management) |
| Sync Workflow | Site code must stay private and Git automation is acceptable | Medium/High (CI + secrets) |

Pick the smallest viable setup now; you can evolve toward a private repo + CI sync later without relocating the Markdown content.
