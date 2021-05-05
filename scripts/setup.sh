#!/bin/bash

# Utility for installing required software
# Version: 1.0
# Author: Paul Carlton (mailto:paul.carlton@weave.works)

# Set versions of software required
linter_version=1.38.0
kubebuilder_version=2.3.1
mockgen_version=v1.4.4

function usage()
{
    echo "USAGE: ${0##*/}"
    echo "Install software required for golang project"
}

function args() {
    while [ $# -gt 0 ]
    do
        case "$1" in
            "--help") usage; exit;;
            "-?") usage; exit;;
            *) usage; exit;;
        esac
    done
}

function install_linter() {
    TARGET=$(go env GOPATH)
    curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sh -s -- -b "${TARGET}/bin" v${linter_version}
}

function install_kubebuilder() {
    os=$(go env GOOS)
    arch=$(go env GOARCH)

    # download kubebuilder and extract it to tmp
    curl -L https://go.kubebuilder.io/dl/${kubebuilder_version}/${os}/${arch} | tar -xz -C /tmp/

    # move to a long-term location and put it on your path
    # (you'll need to set the KUBEBUILDER_ASSETS env var if you put it somewhere else)
    $sudo mv /tmp/kubebuilder_${kubebuilder_version}_${os}_${arch} /usr/local/kubebuilder
    echo "add the following to your bash profile"
    echo "export PATH=\$PATH:/usr/local/kubebuilder/bin"
}

args "${@}"

sudo -E env >/dev/null 2>&1
if [ $? -eq 0 ]; then
    sudo="sudo -E"
fi

echo "Running setup script to setup software"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

golangci-lint --version 2>&1 | grep $linter_version >/dev/null
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    echo "installing linter version: ${linter_version}"
    install_linter
    golangci-lint --version 2>&1 | grep $linter_version >/dev/null
    ret_code="${?}"
    if [ "${ret_code}" != "0" ] ; then
        echo "Failed to install linter"
        echo "version:$(golangci-lint --version)"
        echo "expecting: $linter_version"
        exit 1
    fi
else
    echo "linter version: $(golangci-lint --version)"
fi

export PATH=$PATH:/usr/local/kubebuilder/bin
kubebuilder version 2>&1 | grep ${kubebuilder_version} >/dev/null
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    echo "installing kubebuilder version: ${kubebuilder_version}"
    install_kubebuilder
    kubebuilder version 2>&1 | grep ${kubebuilder_version} >/dev/null
    ret_code="${?}"
    if [ "${ret_code}" != "0" ] ; then
        echo "Failed to install kubebuilder"
        exit 1
    fi
else
   echo "kubebuilder version: $(kubebuilder version)"     
fi

mockgen -version 2>&1 | grep ${mockgen_version} >/dev/null
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    echo "installing mockgen version: ${mockgen_version}"
    GO111MODULE=on go get github.com/golang/mock/mockgen@${mockgen_version}
    mockgen -version 2>&1 | grep ${mockgen_version} >/dev/null
    ret_code="${?}"
    if [ "${ret_code}" != "0" ] ; then
        echo "Failed to install helm"
        exit 1
    fi
else
    echo "mockgen version: $(mockgen -version)"
fi

flux --version >/dev/null 2>&1 
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    brew install flux
else
    echo "flux version: $(flux --version)"
fi

helm version >/dev/null 2>&1
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    brew install helm
else
    echo "helm version: $(helm version)"
fi

kind version >/dev/null 2>&1 
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    brew install kind
else
    echo "kind version: $(kind version)"
fi

kubectl version --client >/dev/null 2>&1 
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    brew install kubectl
else
    echo "kubectl version: $(kubectl version --client)"
fi

kustomize version >/dev/null 2>&1
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    brew install kustomize
else
    echo "kustomize version: $(kustomize version)"
fi

kubeseal --version >/dev/null 2>&1
ret_code="${?}"
if [[ "${ret_code}" != "0" ]] ; then
    brew install kubeseal
else
    echo "kubeseal version: $(kubeseal --version)"
fi