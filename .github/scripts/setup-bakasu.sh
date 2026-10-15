#!/usr/bin/env bash
set -euo pipefail

BAKASU_REPO="${BAKASU_REPO:-https://github.com/Baka-SU/BakaSU.git}"
BAKASU_REF="${1:-${BAKASU_REF:-main}}"

KERNEL_DIR="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "${KERNEL_DIR}"

rm -rf KernelSU KernelSU-Next
git clone --depth 1 --branch "${BAKASU_REF}" "${BAKASU_REPO}" KernelSU || {
    echo "Shallow clone failed for ${BAKASU_REF}, falling back to full clone..."
    git clone "${BAKASU_REPO}" KernelSU
    git -C KernelSU checkout "${BAKASU_REF}"
}

rm -f drivers/kernelsu
ln -s ../KernelSU/kernel drivers/kernelsu

echo "BakaSU ready at $(git -C KernelSU rev-parse HEAD)"
