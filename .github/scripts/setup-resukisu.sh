#!/usr/bin/env bash
set -euo pipefail

RESUKISU_REPO="${RESUKISU_REPO:-https://github.com/ReSukiSU/ReSukiSU.git}"
RESUKISU_REF="${1:-${RESUKISU_REF:-main}}"

KERNEL_DIR="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "${KERNEL_DIR}"

rm -rf KernelSU KernelSU-Next
git clone --depth 1 --branch "${RESUKISU_REF}" "${RESUKISU_REPO}" KernelSU || {
    echo "Shallow clone failed for ${RESUKISU_REF}, falling back to full clone..."
    git clone "${RESUKISU_REPO}" KernelSU
    git -C KernelSU checkout "${RESUKISU_REF}"
}

rm -f drivers/kernelsu
ln -s ../KernelSU/kernel drivers/kernelsu

echo "ReSukiSU ready at $(git -C KernelSU rev-parse HEAD)"
