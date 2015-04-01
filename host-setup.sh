#!/bin/bash

echo Installing Docker..
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
  --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install -y lxc-docker

echo Installing Weave..
sudo wget -O /usr/local/bin/weave \
  https://github.com/zettio/weave/releases/download/latest_release/weave
sudo chmod a+x /usr/local/bin/weave
