#!/usr/bin/env bash

# Cody Bunch
# blog.codybunch.com
# Updates the cloud-init vib name in the packer-template

pushd http/

# Find most recent cloud-init
latestBuild=$(ls -t cloud-init* | head -1)
filename=$(basename $latestBuild)
updatedName="${filename%.*}"

popd

# Update the template
cat <<< $(jq --arg variable "$updatedName" '."variables"."cloud-init" = $variable' new-template.json) > new-template.json