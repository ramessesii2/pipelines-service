#!/usr/bin/env bash

# Copyright 2022 The Pipeline Service Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(
    cd "$(dirname "$0")" >/dev/null
    pwd
)"
PROJECT_DIR="$(
    cd "$SCRIPT_DIR/../.." >/dev/null || exit 1
    pwd
)"
export PROJECT_DIR

usage() {
    echo "
Usage:
    ${0##*/} [options]

Run yamllint in the content of the workspace directory

Optional arguments:
    -w, --workspace_dir WORKSPACE_DIR.
        Workspace directory.
        Default: $PROJECT_DIR
    -d, --debug
        Activate tracing/debug mode.
    -h, --help
        Display this message.

Example:
    ${0##*/} --workspace_dir \$PWD
" >&2
}

parse_args() {
    WORKSPACE_DIR="$PROJECT_DIR"
    while [[ $# -gt 0 ]]; do
        case $1 in
        -w | --workspace_dir)
            shift
            WORKSPACE_DIR="$1"
            ;;
        -d | --debug)
            set -x
            DEBUG="--debug"
            export DEBUG
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown argument: $1" >&2
            usage
            exit 1
            ;;
        esac
        shift
    done
}

init() {
    hadolint --version
}

run() {
    find "$WORKSPACE_DIR" -name Dockerfile -exec \
        hadolint -c "$SCRIPT_DIR/../config/hadolint.yaml" {} +
}

main() {
    if [ -n "${DEBUG:-}" ]; then
        set -x
    fi
    parse_args "$@"
    init
    run
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    main "$@"
fi
