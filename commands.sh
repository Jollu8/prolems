#!/usr/bin/env bash
set -euo pipefail

APP_NAME="commands"
DEFAULT_PYTHON="3.12"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$SCRIPT_DIR"

# Force uv to use only managed Python installations.
export UV_MANAGED_PYTHON=1
# Common locations after uv installation.
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

log() {
    printf '[%s] %s\n' "$APP_NAME" "$*"
}

err() {
    printf '[%s] ERROR: %s\n' "$APP_NAME" "$*" >&2
    exit 1
}

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

project_root_check() {
    [ -f "$PROJECT_ROOT/pyproject.toml" ] || err "pyproject.toml was not found next to the script."
}

python_version() {
    if [ -f "$PROJECT_ROOT/.python-version" ]; then
        tr -d '[:space:]' < "$PROJECT_ROOT/.python-version"
    else
        printf '%s' "$DEFAULT_PYTHON"
    fi
}

install_uv() {
    if has_cmd uv; then
        return 0
    fi

    log "uv was not found, installing..."
    if has_cmd curl; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    elif has_cmd wget; then
        wget -qO- https://astral.sh/uv/install.sh | sh
    else
        err "curl or wget is required to install uv."
    fi

    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

    has_cmd uv || err "uv was installed but is not available in PATH. Add ~/.local/bin to PATH and try again."
}

setup_env() {
    project_root_check
    install_uv

    local pyver
    pyver="$(python_version)"

    if [ ! -f "$PROJECT_ROOT/.python-version" ]; then
        printf '%s\n' "$pyver" > "$PROJECT_ROOT/.python-version"
    fi

    log "Installing Python $pyver with uv..."
    (
        cd "$PROJECT_ROOT"
        uv python install "$pyver"
        uv sync --managed-python
    )

    log "Environment is ready."
}

clean_local_env() {
    project_root_check

    log "Removing local environment and caches..."
    rm -rf \
        "$PROJECT_ROOT/.venv" \
        "$PROJECT_ROOT/.pytest_cache" \
        "$PROJECT_ROOT/.ruff_cache"

    find "$PROJECT_ROOT" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find "$PROJECT_ROOT" -type f \( -name "*.pyc" -o -name "*.pyo" \) -delete 2>/dev/null || true
}

reset_env() {
    clean_local_env
    setup_env
}

ensure_env() {
    install_uv

    if [ ! -d "$PROJECT_ROOT/.venv" ]; then
        setup_env
        return 0
    fi

    (
        cd "$PROJECT_ROOT"
        uv sync --managed-python
    ) >/dev/null
}

run_pytest() {
    ensure_env

    local selector=""
    local file=""
    local name=""
    local file_part=""
    local -a extra_args=()

    while [ $# -gt 0 ]; do
        case "$1" in
            --name-test)
                shift
                [ $# -gt 0 ] || err "Expected a test name after --name-test."
                selector="$1"
                shift
                ;;
            *)
                extra_args+=("$1")
                shift
                ;;
        esac
    done

    if [ -n "$selector" ]; then
        case "$selector" in
            *"::"*|*.py)
                (
                    cd "$PROJECT_ROOT"
                    uv run --managed-python pytest -v "$selector" "${extra_args[@]}"
                )
                return 0
                ;;
            */*)
                file_part="${selector%%/*}"
                name="${selector#*/}"
                file="$(find "$PROJECT_ROOT/tests" -type f -name "test_${file_part}.py" | head -n 1)"
                [ -n "$file" ] || err "Could not find tests/**/test_${file_part}.py"
                (
                    cd "$PROJECT_ROOT"
                    uv run --managed-python pytest -v "$file" -k "$name" "${extra_args[@]}"
                )
                return 0
                ;;
            *)
                (
                    cd "$PROJECT_ROOT"
                    uv run --managed-python pytest -v -k "$selector" "${extra_args[@]}"
                )
                return 0
                ;;
        esac
    fi

    (
        cd "$PROJECT_ROOT"
        uv run --managed-python pytest -v "${extra_args[@]}"
    )
}

run_check_style() {
    ensure_env

    local fix="0"
    local -a extra_args=()

    while [ $# -gt 0 ]; do
        case "$1" in
            --fix)
                fix="1"
                shift
                ;;
            *)
                extra_args+=("$1")
                shift
                ;;
        esac
    done

    if [ "$fix" = "1" ]; then
        (
            cd "$PROJECT_ROOT"
            uv run --managed-python ruff check --fix . "${extra_args[@]}"
            uv run --managed-python ruff format . "${extra_args[@]}"
        )
    else
        (
            cd "$PROJECT_ROOT"
            uv run --managed-python ruff check . "${extra_args[@]}"
            uv run --managed-python ruff format --check . "${extra_args[@]}"
        )
    fi
}

show_help() {
    cat <<'EOF'
commands - project command runner

Usage:
  commands setup
  commands reset
  commands pytest [pytest arguments]
  commands pytest --name-test <selector>
  commands check-style [--fix]

Commands:
  setup
      Install uv if needed, install the required Python version,
      and create the local virtual environment.

  reset
      Remove the local virtual environment and caches,
      then rebuild everything from scratch.

  pytest
      Run the test suite.

      Examples:
        commands pytest
        commands pytest -q
        commands pytest --name-test palindrome/is_palindrome
        commands pytest --name-test tests/recursive/test_palindrome.py::test_is_palindrome

  check-style
      Run code style checks.

      Without --fix:
        - ruff check .
        - ruff format --check .

      With --fix:
        - ruff check --fix .
        - ruff format .

EOF
}

main() {
    project_root_check

    local cmd="${1:-}"
    if [ $# -gt 0 ]; then
        shift
    fi

    case "$cmd" in
        setup)
            setup_env "$@"
            ;;
        reset)
            reset_env "$@"
            ;;
        pytest)
            run_pytest "$@"
            ;;
        check-style)
            run_check_style "$@"
            ;;
        ""|-h|--help|help)
            show_help
            ;;
        *)
            err "Unknown command: $cmd"
            ;;
    esac
}

main "$@"