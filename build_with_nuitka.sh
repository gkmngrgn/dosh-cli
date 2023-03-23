#!/bin/bash

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PY="$(command -v python3 || command -v python)"

if command -v poetry &> /dev/null
then
    echo "poetry found in path."
else
    $PY -m pip install --user pipx
    $PY -m pipx install poetry
fi

OS_NAME=$($PY -c 'import platform; print(platform.system().lower())')
ARCH_TYPE=$($PY -c 'import platform; print(platform.machine().lower())')
PY_VERSION=$($PY -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
DOSH_VERSION=$(poetry version --no-ansi --short)
DIR_NAME="dosh-cli-${OS_NAME}-${ARCH_TYPE}-${DOSH_VERSION}"

echo "---"
echo "PYTHON PATH    : ${PY}"
echo "PYTHON VERSION : ${PY_VERSION}"
echo "DIRECTORY      : ${DIR_NAME}"
echo "---"

poetry install --no-ansi --no-interaction
poetry run python                  \
        -m nuitka                  \
        --standalone               \
        --remove-output            \
        --assume-yes-for-downloads \
        --output-filename=dosh     \
        dosh_cli
[ -d "${DIR_NAME}" ] && rm -rf "${DIR_NAME}"
mv dosh_cli.dist "${DIR_NAME}"
