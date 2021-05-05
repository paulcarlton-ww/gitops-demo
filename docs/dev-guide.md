# Developer Guide

This readme contains guidance to help setup an environment for demo.

## Setup

fork [[GitOps Task]](https://github.com/paulcarlton-ww) or fork it and clone your fork.

### Install Required Software

This project requires the following software:

    [flux](https://toolkit.fluxcd.io/)
    helm
    kubectl
    [kind](https://kind.sigs.k8s.io/docs/)
    kubeseal

You can install these using the 'setup.sh' script:

    scripts/setup.sh

### Create Kubernetes Cluster

You will require a Kubernetes cluster. You can use the script provided to provision a kind cluster or provision a cluster yourself.

    scripts/kind.sh

## Demo

Scripts are provided to automate task completion. Start by bootstraping flux:

    flux-setup.sh