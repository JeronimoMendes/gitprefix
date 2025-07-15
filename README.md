# gitprefix

A pre-commit hook that automatically prefixes commit messages with issue numbers or branch names based on your Git branch naming convention.

## Features

- Automatically prefixes commit messages with issue numbers from branches like `issues/123-feature-name`
- Prefixes with full branch name for release branches like `release/v1.1.0`
- Works seamlessly with the pre-commit framework

## Usage

### Basic Usage

Add this to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/JeronimoMendes/gitprefix
    rev: 1.0.0
    hooks:
      - id: gitprefix
```

Then install the hook:

```bash
pre-commit install --hook-type prepare-commit-msg
```

### Customization

You can customize the hook behavior with arguments:

```yaml
repos:
  - repo: https://github.com/JeronimoMendes/gitprefix
    rev: 1.0.0
    hooks:
      - id: gitprefix
        args: [
          '--issue-pattern', 'feature/([A-Z]+-[0-9]+)',
          '--issue-prefix', '[%s] ',
          '--position', 'suffix'
        ]
```

#### Available Options

- `--issue-pattern`: Regex pattern to extract issue numbers (default: `issues/([0-9]+)`)
- `--release-pattern`: Regex pattern to extract release names (default: `release/(.*)`)
- `--issue-prefix`: Format string for issue numbers (default: `(#%s) `)
- `--release-prefix`: Format string for release names (default: `(%s) `)
- `--position`: Where to place the prefix - `prefix` or `suffix` (default: `prefix`)

#### Examples

**JIRA-style branches:**
```yaml
args: ['--issue-pattern', 'feature/([A-Z]+-[0-9]+)', '--issue-prefix', '[%s] ']
```
Branch `feature/PROJ-123` → `[PROJ-123] your commit message`

**GitHub issue style with suffix:**
```yaml
args: ['--issue-pattern', 'issue-([0-9]+)', '--issue-prefix', '(closes #%s)', '--position', 'suffix']
```
Branch `issue-456` → `your commit message (closes #456)`

**Custom patterns:**
```yaml
args: [
  '--issue-pattern', 'bugfix/([0-9]+)',
  '--issue-prefix', '🐛 Fix #%s: ',
  '--release-pattern', 'hotfix/(.*)',
  '--release-prefix', '🚨 %s: '
]
```

## Default Branch Naming Convention

Without customization, this hook works with:

- `issues/123-feature-description` → `(#123) your commit message`
- `release/v1.1.0` → `(release/v1.1.0) your commit message`

## Contributing

All contributions are welcome, feel free to open an issue to discuss features or bugs and open a PR.