#!/bin/bash

# Utility for deploying podinfo
# Version: 1.0
# Author: Paul Carlton (mailto:paul.carlton@weave.works)

mkdir clusters/aks-demo/podinfo

flux create source git podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=30s \
  --export > ./clusters/aks-demo/podinfo/podinfo-source.yaml

git add -A && git commit -m "Add podinfo GitRepository"
git push

flux create kustomization podinfo \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --validation=client \
  --interval=5m \
  --export > ./clusters/aks-demo/podinfo/podinfo-kustomization.yaml

git add -A && git commit -m "Add podinfo Kustomization"
git push

