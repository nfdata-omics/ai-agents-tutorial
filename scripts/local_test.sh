#!/bin/bash

TUTORIAL_NAME="ai-agents-tutorial"
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR=${HOME}/${TUTORIAL_NAME}-workspace/
mkdir -p ${WORK_DIR}

docker run --rm -it \
  --name ${TUTORIAL_NAME} \
  --cpus="2" \
  --memory="8g" \
  --memory-swap="8g" \
  -v "${WORK_DIR}:/workspaces/" \
  -v "${PARENT_DIR}:/workspaces/nfdata-omics-${TUTORIAL_NAME}" \
  -w /workspaces/nfdata-omics-${TUTORIAL_NAME} \
  -e HOST_PROJECT_PATH=/workspaces/nfdata-omics-${TUTORIAL_NAME} \
  -p 8888:8888 \
  ghcr.io/nfdata-omics/${TUTORIAL_NAME}:2026-07-02 \
  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
