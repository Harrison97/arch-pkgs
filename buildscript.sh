#!/bin/bash
# Wraps aursync command to mount an amazon s3 bucket which contains a repository
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

REMOTE_PATH=s3://harrison-arch-repo/repo/x86_64
LOCAL_PATH=$HOME/.local/share/arch-repo
REPO_NAME=harrison

PACKAGES=${@:-pkg/*}
CHROOT="$PWD/root"

mkdir -p "$LOCAL_PATH"
mkdir -p "$CHROOT"

[[ -d "$CHROOT/root" ]] || mkarchchroot -C /etc/pacman.conf "$CHROOT/root" base base-devel

for package in $PACKAGES; do
    cd "$package"
    rm -f *.pkg.tar.xz
    makechrootpkg -cur $CHROOT
    cd -
done

s3cmd sync "$REMOTE_PATH/$REPO_NAME".{db,files}.tar.xz "$LOCAL_PATH/"
ln -sf "$REPO_NAME.db.tar.xz" "$LOCAL_PATH/$REPO_NAME.db"
ln -sf "$REPO_NAME.files.tar.xz" "$LOCAL_PATH/$REPO_NAME.files"

repo-add "$LOCAL_PATH/$REPO_NAME.db.tar.xz" "${PACKAGES[@]}/"*.pkg.tar.xz
s3cmd sync --follow-symlinks --acl-public \
    "${PACKAGES[@]}/"*.pkg.tar.xz \
    "$LOCAL_PATH/$REPO_NAME".{db,files}{,.tar.xz} \
    "$REMOTE_PATH/"
