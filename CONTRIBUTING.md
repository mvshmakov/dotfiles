# Contributing to dotfiles

Inspired by LunarVim [contributing guideline](https://github.com/LunarVim/LunarVim/blob/rolling/CONTRIBUTING.md).

## Setting up development tools

### For editing shell scripts

1. Formatter: [shfmt](https://github.com/mvdan/sh#shfmt).
2. Linter: [shellcheck](https://github.com/koalaman/shellcheck).

### (Optional)

Install [pre-commit](https://github.com/pre-commit/pre-commit) which will run all linters and formatters for you as a pre-commit-hook.

## Code Conventions

All shell code is formatted according to [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html). Use two spaces instead of tabs.

```sh
shfmt -i 2 -ci -bn -l -d .
```

## Pull Requests (PRs)

- Use a [rebase-workflow](http://git-scm.com/book/en/v2/Git-Branching-Rebasing).

### Branch Naming

Name your branches meaningfully.

**Real world example:**
```(feature|bugfix|hotfix)/what-my-pr-does```

### Commit Messages

- Commit header is limited to 72 characters.
- Commit body and footer is limited to 100 characters per line.

**Commit header format:**

```md
<type>(<scope>?): <summary>
  │       │           │
  │       │           └─> Present tense.     'add something...'(O) vs 'added something...'(X)
  │       │               Imperative mood.   'move cursor to...'(O) vs 'moves cursor to...'(X)
  │       │               Not capitalized.
  │       │               No period at the end.
  │       │
  │       └─> Commit Scope is optional, but strongly recommended.
  │           Use lower case.
  │           'plugin', 'file', or 'directory' name is suggested, but not limited.
  │
  └─> Commit Type: build|ci|docs|feat|fix|perf|refactor|test
```

#### Commit Type Guideline

- **build**: changes that affect the build system or external dependencies (example scopes: npm, pip, rg)
- **ci**: changes to CI configuration files and scripts (example scopes: format, lint, issue_templates)
- **docs**: changes to the documentation only
- **feat**: new feature for the user
- **fix**: bug fix
- **perf**: performance improvement
- **refactor**: code change that neither fixes a bug nor adds a feature
- **test**: adding missing tests or correcting existing tests
- **chore**: all the rest, including version bump for plugins

**Real world examples:**

```feat(quickfix): add 'q' binding to quit quickfix window when focused```

```fix(installer): add missing "HOME" variable```
