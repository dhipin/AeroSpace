#!/usr/bin/env bash
# Fork-local entry point: build AeroSpace from sources and install it as the `aerospace-dev` brew cask.
#
# Differences from ./install-from-sources.sh:
# - Puts keg-only rustup (Homebrew) and swiftly on PATH, so ./script/setup.sh picks them up
#   without editing shell profiles.
# - Signs with an existing "Apple Development" identity from the login keychain instead of the
#   self-signed `aerospace-codesign-certificate`. A stable signing identity keeps the Accessibility
#   permission valid across rebuilds.
#
# Override the identity with AEROSPACE_CODESIGN_IDENTITY="<name or SHA-1>" ./install-local.sh
set -e
set -u
set -o pipefail
cd "$(dirname "$0")"

# Append, not prepend: a version manager (rbenv) earlier on PATH must keep precedence over
# Homebrew's ruby/bundle, because Gemfile pins ruby ~> 3.0
if test -x /opt/homebrew/bin/brew && ! grep -q '/opt/homebrew/bin' <<< "$PATH"; then
    PATH="$PATH:/opt/homebrew/bin"
fi
if brew --prefix rustup &> /dev/null; then
    PATH="$(brew --prefix rustup)/bin:$PATH"
fi
if test -f "${SWIFTLY_HOME_DIR:-$HOME/.swiftly}/env.sh"; then
    source "${SWIFTLY_HOME_DIR:-$HOME/.swiftly}/env.sh"
fi
export PATH

if test -z "${AEROSPACE_CODESIGN_IDENTITY:-}"; then
    AEROSPACE_CODESIGN_IDENTITY=$(security find-identity -v -p codesigning \
        | sed -n 's/^ *[0-9]*) [0-9A-F]* "\(Apple Development: .*\)"$/\1/p' | head -1)
fi
if test -z "$AEROSPACE_CODESIGN_IDENTITY"; then
    AEROSPACE_CODESIGN_IDENTITY="aerospace-codesign-certificate"
fi
export AEROSPACE_CODESIGN_IDENTITY
echo "Codesign identity: $AEROSPACE_CODESIGN_IDENTITY"

# bash 5 is required by ./script/setup.sh. Homebrew's bash comes first on PATH above
exec bash ./install-from-sources.sh "$@"
