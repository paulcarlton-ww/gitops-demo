#!/bin/bash

# Utility for starting kind
# Version: 1.0
# Author: Paul Carlton (mailto:paul.carlton@weave.works)

set -o errexit

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-k8s}"
MY_IP="${MY_IP:-localhost}"
MY_PORT="${MY_PORT:-16443}"
TOP=$(git rev-parse --show-toplevel)

sed s/MY_IP/$MY_IP/ ${TOP}/resources/kind.yaml | sed s/MY_PORT/$MY_PORT/ |\
    kind create cluster --name "${KIND_CLUSTER_NAME}" --config -
