#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} -sL https://api.github.com/repos/zen-browser/desktop/releases | jq -r '.[0].tag_name')
currentVersion=$(nix eval --raw .#zen-browser-bin-unwrapped.version)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash_linux=$(nix-prefetch-url https://github.com/zen-browser/desktop/releases/download/${latestVersion}/zen.linux-x86_64.tar.xz)
hash_linux=$(nix --extra-experimental-features nix-command hash convert "sha256:$hash_linux")
echo x86_64-linux: $hash_linux

hash_linux_arm=$(nix-prefetch-url https://github.com/zen-browser/desktop/releases/download/${latestVersion}/zen.linux-aarch64.tar.xz)
hash_linux_arm=$(nix --extra-experimental-features nix-command hash convert "sha256:$hash_linux_arm")
echo aarch64-linux: $hash_linux_arm
