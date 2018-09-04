#!/bin/bash

for PYVER in 2.7 3.6; do
    if [[ $PYVER == 2.7 ]]; then
        env_file=env_create_py2.yaml
    elif [[ $PYVER == 3.* ]]; then
        env_file=env_create.yaml
    fi

    tag=slaclcls/travis:ubuntu16.04-py$PYVER
    docker build --build-arg CONDA_ENV_FILE=$env_file -t $tag -f docker/Dockerfile.ubuntu . && docker push $tag

    tag=slaclcls/travis:centos6-py$PYVER
    docker build --build-arg CONDA_ENV_FILE=$env_file -t $tag -f docker/Dockerfile.centos . && docker push $tag
done