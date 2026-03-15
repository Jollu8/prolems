# problems

A collection of Python problems with an isolated local environment managed through `uv`.

This project is intentionally configured to **avoid depending on the system Python**.  
All commands are run through the `problems` script, which checks the environment and uses the local `.venv`.

## Project structure

```text
problems/
├─ pyproject.toml
├─ .python-version
├─ problems
├─ src/
│  └─ problems/
│  |  ├─ __init__.py
│  |  ├─ recursive/
│  |  │  ├─ __init__.py
│  |  │  └─ palindrome.py
|  ├─ etc/...
└─ tests/
   ├─ recursive/
   │  └─ test_palindrome.py
   ├─ etc/...
   └─ conftest.py
````

## Requirements

* Unix / Linux / macOS
* `bash`
* `curl` or `wget` for automatic `uv` installation

## What the `commands` script does

The `commands` script:

* installs `uv` if it is missing;
* installs the required Python version if it is missing;
* creates a local `.venv`;
* runs tests;
* checks code style;
* can fully rebuild the environment if needed.

## First run

From the project root:

```bash
./commands setup
```

This command:

* installs `uv` if it is not installed;
* installs the Python version from `.python-version`;
* creates a local `.venv`;
* installs project dependencies.

## Rebuild the environment

If the environment is broken or dependency conflicts appear:

```bash
./commands reset
```

This command removes:

* `.venv`
* `.pytest_cache`
* `.ruff_cache`
* `__pycache__`
* `*.pyc`

After that, the environment is created again from scratch.

## Run tests

Run all tests:

```bash
./commands pytest
```

Run pytest with extra arguments:

```bash
./commands pytest -q
./commands pytest -x
./commands pytest -vv
```

Run a single test using a short selector:

```bash
./commands pytest --name-test palindrome/is_palindrome
```

This format means:

* `palindrome` → file `test_palindrome.py`
* `is_palindrome` → test name filter passed through `pytest -k`

Run a test using a full `pytest` node id:

```bash
./commands pytest --name-test tests/recursive/test_palindrome.py::test_is_palindrome
```

## Check code style

Check style without modifying files:

```bash
./commands check-style
```

This command runs:

* `ruff check .`
* `ruff format --check .`

Automatically fix some issues and format the code:

```bash
./commands check-style --fix
```

This command runs:

* `ruff check --fix .`
* `ruff format .`

## Command summary

```bash
./commands setup
./commands reset
./commands pytest
./commands pytest --name-test palindrome/is_palindrome
./commands pytest --name-test tests/recursive/test_palindrome.py::test_is_palindrome
./commands check-style
./commands check-style --fix
```

## Run without `./`

You can add the script to your `PATH`, for example with a symlink:

```bash
ln -sf "$(pwd)/problems" "$HOME/.local/bin/problems"
```

After that, you can run:

```bash
problems setup
problems pytest
problems check-style --fix
```

Make sure `$HOME/.local/bin` is included in your `PATH`.

## Why this project uses `uv`

A system may have multiple Python installations, which often leads to version and dependency conflicts.
This project uses `uv` to:

* avoid relying on the system Python;
* keep the environment local to the project;
* rebuild the environment quickly;
* run the project the same way on different machines.

## Useful notes

The project Python version is defined in:

```text
.python-version
```

The supported Python versions are defined in:

```toml
[project]
requires-python = ">=3.12"
```

## Recommended workflow

In most cases, this is enough:

```bash
./commands setup
./commands check-style
./commands pytest
```

If something breaks:

```bash
./commands reset
```
