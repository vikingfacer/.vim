#!/usr/bin/env bash

OWNER=$1;
REPO=$2;

#mkdir -p pack/plugins/start/$REPO;

git submodule add https://github.com/$OWNER/$REPO pack/plugins/start/$REPO

