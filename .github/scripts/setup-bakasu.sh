#!/usr/bin/env bash
set -euo pipefail

BAKASU_REPO="${BAKASU_REPO:-https://github.com/Baka-SU/BakaSU.git}"
BAKASU_REF="${1:-${BAKASU_REF:-5b76b884c75f729a220bb317aa4a4fc78f0e0e9c}}"

KERNEL_DIR="${2:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "${KERNEL_DIR}"

rm -rf KernelSU KernelSU-Next
if git clone --depth 1 --branch "${BAKASU_REF}" "${BAKASU_REPO}" KernelSU 2>/dev/null; then
    echo "Shallow cloned ${BAKASU_REF}"
else
    echo "Fetching ${BAKASU_REF} from ${BAKASU_REPO}..."
    git clone --depth 50 "${BAKASU_REPO}" KernelSU || git clone "${BAKASU_REPO}" KernelSU
    git -C KernelSU checkout "${BAKASU_REF}"
fi

# Remove temporary upstream build error on main for SuSFS if present
if [ -f "KernelSU/kernel/tools/susfs_compat.mk" ]; then
    sed -i '/Please wait susfs update/d' KernelSU/kernel/tools/susfs_compat.mk 2>/dev/null || true
fi

rm -f drivers/kernelsu
ln -s ../KernelSU/kernel drivers/kernelsu

echo "BakaSU ready at $(git -C KernelSU rev-parse HEAD)"
