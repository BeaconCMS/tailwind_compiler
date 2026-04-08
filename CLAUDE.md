# Rules

- *NEVER* attempt to use any historically destructive git commands
- *ALWAYS* make small and frequent commits
- This project uses Zig 0.15 and you must respect the available API for that version
- All tests must pass, do not ignore failing tests that you believe are unrelated to your work. Only fix those failing tests after you've completed and validated your work. The last step of any job you do should be to ensure all tests pass.
- *NEVER* attempt to launch the Zig documentation, it is a web app that you cannot access. Instead you *MUST* search the documentation on the ziglang website

## Release Process

When the user says "release" (or similar), follow this procedure:

### 1. Determine the version

- If the user specifies a version, use it.
- *MUST* read the current version from `build.zig.zon` first and treat that source-code version as the canonical baseline for the next release. Do not derive the baseline version from git tags, commit messages, or GitHub releases when they disagree with the source tree.
- Do **NOT** bump to `0.1.0` or higher without explicit permission from the user. Continue incrementing `0.0.x` until told otherwise.
- Otherwise, analyze the unreleased commits since the last release commit/tag that matches the source-code version lineage and apply [Semantic Versioning](https://semver.org/):
  - **patch** (0.0.x): bug fixes, build fixes, documentation, dependency updates, new features (while on 0.0.x)
- If tags or history suggest a higher version than `build.zig.zon`, treat that as drift to be corrected instead of as the next release baseline.

### 2. Update version strings

Both version files **must** be kept in lockstep:
- `build.zig.zon` — `.version = "X.Y.Z",`
- `mix.exs` — `version: "X.Y.Z"`

### 3. Review and update README.md

Ensure the README accurately reflects the current state of the project:
- New features or API changes are documented
- Installation instructions are current
- Examples and usage sections match the actual interface

### 4. Commit, tag, and push

```sh
git add build.zig.zon mix.exs README.md
git commit -m "Release X.Y.Z"
git tag vX.Y.Z
git push && git push origin vX.Y.Z
```

The GitHub Actions release workflow handles the rest: running tests on all architectures, building precompiled NIF binaries, and creating the GitHub Release.
