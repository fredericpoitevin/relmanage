#!/usr/bin/env bash


set -e


# check which psana (1-py2, 1-py3 or 2) to build 
PSANA_BUILD="2"
if [[ $# -eq 1 ]]; then
    PSANA_BUILD=${1}
fi


# Cori has a dedicated `git-lfs module`
if [[ $NERSC_HOST = "cori" ]]; then
    module load git-lfs
fi

git lfs install
git lfs pull
git submodule update --init


# use absolute paths:
project_root=$(readlink -f $(dirname ${BASH_SOURCE[0]}))


# set parameters for different build
case "$PSANA_BUILD" in
    2)
        PSANA_REPO="slaclcls/lcls2"
        PSANA_PKG_NAME="psana"
        PSANA_VERSION_PREFIX="ps"
        PSANA_VERSION=3.0.1
        PYVER=3.7
        ;;

    1-py2)
        PSANA_REPO="slaclcls/lcls-py2"
        PSANA_PKG_NAME="psana-conda"
        PSANA_VERSION_PREFIX="ana"
        PSANA_VERSION=2.0.6
        PYVER=2.7
        ;;

    1-py3)
        PSANA_REPO="slaclcls/lcls-py3"
        PSANA_PKG_NAME="psana-conda"
        PSANA_VERSION_PREFIX="ana"
        PSANA_VERSION=2.0.6
        PYVER=3.7
        ;;
    
    *)
        echo "Please enter build option: 2, 1-py2, or 1-py3"
        exit 1
esac

echo "build    : $PSANA_REPO"
echo "conda pkg: $PSANA_PKG_NAME"
echo "version  : $PSANA_VERSION_PREFIX-$PSANA_VERSION"

docker build                                    \
    -t ${PSANA_REPO}:latest                    \
    -t ${PSANA_REPO}:$PSANA_VERSION_PREFIX-$PSANA_VERSION         \
    -f $project_root/docker/Dockerfile.base     \
    --no-cache                                  \
    --build-arg PYVER=$PYVER                       \
    --build-arg PSANA_PKG_NAME=$PSANA_PKG_NAME  \
    --build-arg PSANA_VERSION=$PSANA_VERSION    \
    $project_root 