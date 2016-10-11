#!/usr/bin/env bash
set -e

if [[ "$#" < "1" ]]; then
  echo "Usage: $0 IMAGE_TAG"
  echo "  IMAGE_TAG : the Docker image tag for the Junebug image to deploy"
  exit 1
fi

IMAGE_TAG="$1"; shift

# Parse the version of Junebug from the requirements file
JUNEBUG_VERSION="$(sed -E 's/\s*junebug\s*==\s*([^\s\;]+).*/\1/' requirements.txt)"

# Push the current tag
docker push "$IMAGE_TAG"

# Push the versioned tag
VERSION_TAG="${IMAGE_TAG%%:*}:$JUNEBUG_VERSION"
docker tag "$IMAGE_TAG" "$VERSION_TAG"
docker push "$VERSION_TAG"
