# wconf

Personal Windows configuration and dotfiles repository. Centralizes settings for the development environment, keeping everything version-controlled and easy to restore.

## Structure

```
wconf/
├── install.ps1                             # Symlink installer script
├── .gitconfig                              # Git user identity and global settings
├── .megaignore                             # MEGA sync exclusion/inclusion patterns
├── .pylintrc                               # Python linter (pylint) configuration
├── omp.json                                # Oh-My-Posh terminal prompt theme
├── claude/
│   ├── CLAUDE.md                           # Claude Code development guidelines
│   ├── settings.json                       # Claude Code IDE settings
│   └── statusbar.sh                        # Custom status bar script
├── postgresql/
│   └── pgpass.conf                         # PostgreSQL connection credentials
├── sublime_text/
│   ├── Default (Windows).sublime-keymap    # Custom keyboard shortcuts
│   ├── Default (Windows).sublime-mousemap  # Mouse action overrides
│   ├── JSON.sublime-settings               # JSON-specific editor settings
│   ├── Origami.sublime-settings            # Pane management configuration
│   ├── Package Control.sublime-settings    # Package manager and installed packages
│   ├── PersonalPlugins.py                  # Custom Python plugins
│   ├── Preferences.sublime-settings        # Main editor preferences
│   └── Terminus.sublime-settings           # Integrated terminal configuration
└── terminal/
    ├── Microsoft.PowerShell_profile.ps1    # PowerShell startup profile
    └── settings.json                       # Windows Terminal settings
```

## Tools Configured

| Tool | Config file(s) | Purpose |
|---|---|---|
| Git | `.gitconfig` | Version control identity and defaults |
| Pylint | `.pylintrc` | Python static analysis |
| Oh-My-Posh | `omp.json` | Terminal prompt theme |
| Claude Code | `claude/` | AI coding assistant settings |
| PostgreSQL | `postgresql/pgpass.conf` | Database credentials |
| Sublime Text | `sublime_text/` | Primary code editor |
| Windows Terminal | `terminal/settings.json` | Terminal emulator |
| PowerShell | `terminal/Microsoft.PowerShell_profile.ps1` | Shell startup script |

---

## Configuration Details

### Git — `.gitconfig`

- **User**: Alex Occelli (`occelli.alex@gmail.com`)
- **Default branch**: `main`
- **Credential helper**: `cache`

### Python / Pylint — `.pylintrc`

Strict linting for Python 3.12 projects.

- **Max line length**: 120 characters
- **Naming**: `snake_case` for functions/variables/methods, `PascalCase` for classes
- **Init hook**: automatically adds `.` and `src/` to `sys.path`
- **Design limits**: max 5 arguments, 7 attributes, 12 branches per function
- **Disabled checks**: `missing-module-docstring`, `raw-checker-failed`, `deprecated-pragma`
- **Allowed extension modules**: `pyodbc`

### MEGA Sync — `.megaignore`

Excludes version control and editor metadata from MEGA cloud sync:

```
.git, .gitignore, .idea, .obsidian, .venv, __pycache__ (excluded by default)
*.egg-info, __pycache__ (force-included)
```

### Oh-My-Posh — `omp.json`

Two-line prompt with left/right segments:

- **Left**: Python virtual environment · current path · git branch
- **Right**: Command execution time · current time (`HH:MM:SS`)
- **Second line**: `$` / `#` prompt symbol
- **Fonts/Colors**: cyan for venv, blue for path, teal for git

### Claude Code — `claude/`

#### `settings.json`
- Auto-update channel: `latest`
- Custom status line via `~/.claude/statusbar.sh`

#### `statusbar.sh`
Bash script rendering a compact status bar showing:
- Current directory name
- Git branch (when inside a repository)
- Context window usage percentage
- Current time
- Elapsed time since last command (auto-scales: ms / s / m / h)

#### `CLAUDE.md`
Development guidelines applied to all projects:
- Answers in Italian, code/docs written in English
- 4-space indentation (2-space for JSON)
- `snake_case` filenames and variables
- Performance over readability; no redundancy
- README.md required for every project

---

### Sublime Text — `sublime_text/`

#### Editor Preferences (`Preferences.sublime-settings`)

| Setting | Value |
|---|---|
| Font | JetBrains Mono NL, size 13 |
| Color scheme | Monokai |
| Indentation | 4 spaces |
| Line ruler | 120 characters |
| Line numbers | Relative |
| Auto-save | On focus lost |
| Hardware acceleration | OpenGL |

Excluded from file index: `.git`, `.idea`, `__pycache__`, `.venv`, `.pytest_cache`, `*.egg-info`

#### Installed Packages (`Package Control.sublime-settings`)

| Package | Purpose |
|---|---|
| Advanced CSV | CSV file editing utilities |
| rainbow_csv | Column colorization for CSV files |
| Origami | Flexible pane/window splitting |
| Terminus | Integrated terminal emulator |
| UndoTree | Visual undo history browser |

#### Terminus Shells (`Terminus.sublime-settings`)

| Shell | Status | Command |
|---|---|---|
| PowerShell | enabled (default) | `powershell.exe -nologo` |
| CMD | disabled | `cmd.exe` |
| Unix | enabled | WSL Ubuntu |
| PY | enabled | Python 3 interactive REPL |

#### Custom Keybindings (`Default (Windows).sublime-keymap`)

| Shortcut | Action |
|---|---|
| `Alt+R` | Reverse lines |
| `Alt+T` | Trim whitespace |
| `Alt+U` | Remove duplicate lines |
| `Alt+W` | Toggle word wrap |
| `Alt+C` | Toggle comment |
| `Ctrl+Alt+T` | Open terminal at current file path |
| `Ctrl+Alt+L` | Open terminal with shell selector |
| `Ctrl+Alt+M` | Convert lines to quoted string array |
| `Ctrl+Alt+N` | Convert lines to comma-separated values |
| `Shift+F9` | Sort lines by selected column range |
| `Ctrl+Shift+Z` | Show undo tree |

Mouse override: `Ctrl+Scroll` zoom disabled.

#### Custom Plugins (`PersonalPlugins.py`)

Four Sublime Text commands implemented in Python:

| Command | Trigger | Description |
|---|---|---|
| `TrimCommand` | `Alt+T` | Strips leading/trailing whitespace from selected lines |
| `OnRowStringCommand` | `Ctrl+Alt+M` | Converts selected lines into a quoted comma-separated array |
| `OnRowNumberCommand` | `Ctrl+Alt+N` | Joins selected lines as a comma-separated list of values |
| `SortBySelectionCommand` | `Shift+F9` | Sorts all lines by the character range of the current selection |

---

### Windows Terminal — `terminal/settings.json`

**Default profile**: PowerShell
**Default window size**: 70 × 20

| Setting | Value |
|---|---|
| Font | JetBrains Mono NL, size 13 |
| Color scheme | One Half Dark |
| Cursor | Underscore |
| Scrollbar | Hidden |
| Copy on select | Enabled |
| Copy formatting | Plain text only |

#### Profiles

| Profile | Visible | Command |
|---|---|---|
| PowerShell | Yes (default) | `powershell.exe -nologo` |
| CMD | Hidden | `cmd.exe` |
| Unix | Yes | WSL Ubuntu |
| PY | Yes | Python 3.14 |
| PSQL | Yes | `psql postgres://postgres@localhost:5432/postgres` |

#### Key Bindings

| Shortcut | Action |
|---|---|
| `Ctrl+C` | Copy |
| `Ctrl+V` | Paste |
| `Alt+Shift+D` | Duplicate pane |

### PowerShell — `Microsoft.PowerShell_profile.ps1`

Executed on every PowerShell session start:
1. Disables the automatic virtual environment prompt override (`VIRTUAL_ENV_DISABLE_PROMPT=1`)
2. Initializes Oh-My-Posh with `~/omp.json` as the active theme

### PostgreSQL — `postgresql/pgpass.conf`

Stores credentials for passwordless `psql` connections to the local instance (`127.0.0.1:5432`).

---

## Installation

Run `install.ps1` from the repository root to automatically create symbolic links for all configuration files.

```powershell
.\install.ps1
```

The script requires **Administrator privileges** or **Windows Developer Mode** enabled (Settings → System → For developers) to create symlinks.

For each file, the script:
1. Creates the destination directory if it does not exist
2. Renames any existing file at the destination to `<filename>.bak`
3. Creates a symbolic link pointing back to the file in this repository

### Symlink map

| Repository path | Destination |
|---|---|
| `.gitconfig` | `%USERPROFILE%\.gitconfig` |
| `.pylintrc` | `%USERPROFILE%\.pylintrc` |
| `omp.json` | `%USERPROFILE%\omp.json` |
| `claude\CLAUDE.md` | `%USERPROFILE%\.claude\CLAUDE.md` |
| `claude\settings.json` | `%USERPROFILE%\.claude\settings.json` |
| `claude\statusbar.sh` | `%USERPROFILE%\.claude\statusbar.sh` |
| `postgresql\pgpass.conf` | `%APPDATA%\PostgreSQL\pgpass.conf` |
| `sublime_text\*` | `%APPDATA%\Sublime Text\Packages\User\` |
| `terminal\settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| `terminal\Microsoft.PowerShell_profile.ps1` | `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` |

> `.megaignore` is not symlinked — it must be placed manually at the root of the MEGA-synced folder.
