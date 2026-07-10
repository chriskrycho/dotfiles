#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/bin"

cat > "$TEST_ROOT/bin/brew" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

cat > "$TEST_ROOT/bin/fish" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

cat > "$TEST_ROOT/bin/getent" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' 'test-user:x:1000:1000::/home/test-user:/bin/bash'
EOF

cat > "$TEST_ROOT/bin/grep" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

cat > "$TEST_ROOT/bin/sudo" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$TEST_ROOT/sudo-calls"
EOF

chmod +x "$TEST_ROOT/bin/"*

export TEST_ROOT
PATH="$TEST_ROOT/bin:/usr/bin:/bin" \
MISE_PROJECT_ROOT="$REPO_ROOT" \
    timeout 2 bash "$REPO_ROOT/tasks/setup/fish/use_as_default.sh" </dev/null

/usr/bin/grep -Fx -- "-n add-shell $TEST_ROOT/bin/fish" "$TEST_ROOT/sudo-calls"
/usr/bin/grep -Fx -- "-n chsh -s $TEST_ROOT/bin/fish $(id -un)" "$TEST_ROOT/sudo-calls"
