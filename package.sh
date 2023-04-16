#!/bin/bash
set -e

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if command -v pyenv &> /dev/null
then
    echo "pyenv found in path."
    pyenv global system
fi

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
poetry run pyinstaller dosh_cli/__main__.py --name=dosh --copy-metadata=dosh-core --console --noconfirm --clean
[ -d "${DIR_NAME}" ] && rm -rf "${DIR_NAME}"
mv dist/dosh "${DIR_NAME}"
