#!/bin/bash

apt-get update
echo Installing Gitlab-Runner...
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt-get install gitlab-runner
echo Installing Docker...
apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
docker -v
echo Registering Gitlab-Runner...
gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token ${REGISTRATION_TOKEN} \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --name ${NAME} \
  --tag-list "" \
  --run-untagged="true"
gitlab-runner verify
echo Finished executing!