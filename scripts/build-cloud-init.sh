#!/usr/bin/env bash
# Cody Bunch
# blog.codybunch.com
#
# build-cloud-init.sh - Builds and installs cloud-init from source into a venv

#VIB_DESC_FILE=${CLOUDINIT_TEMP_DIR}/descriptor.xml
PAYLOAD_ROOT="${PAYLOAD_ROOT:-/tmp/payloads}"
PAYLOAD_DIR="${PAYLOAD_DIR:-${VIB_PAYLOAD_ROOT}/cloudInit}"
REPO_DIR="${REPO_DIR:-/tmp/cloudinit}"
REPO="${CLOUDINIT_REPO:-'https://github.com/canonical/cloud-init.git'}"
PYTHON_VER="${PYTHON_VER:-3.5.7}"

# Create cloud-init temp dir
#mkdir -p ${CLOUDINIT_TEMP_DIR}
# Create VIB spec payload directory
#mkdir -p ${VIB_PAYLOAD_DIR}esxicloudinit/

# Check for and clone repo if it is missing
if [ -e ${REPO_DIR} ]; then
  echo "Found cloud-init in ${REPO_DIR}"
else
  git clone ${REPO} ${REPO_DIR}
fi
#
# Build cloud-init
#
## Install pyenv
#
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
cat << EOF >> ${HOME}/.bashrc
export PATH="${HOME}/.pyenv/bin:$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF
source ${HOME}/.bashrc
#
## Install python 3.5.7
#
pyenv install ${PYTHON_VER}
export PYENV_VERSION=${PYTHON_VER}
#
## Create venv
#
cd ${PAYLOAD_ROOT}
python3 -m venv cloudInit
cd ${PAYLOAD_DIR}
source bin/activate
#
## Upgrade pip and poetry
#
pip install --upgrade -t ${PAYLOAD_DIR}/package pip
pip install -t ${PAYLOAD_DIR}/package poetry
#
## Install cloud-init requirements to the payload directory
#
cd ${REPO_DIR}
pip install \
  --disable-pip-version-check \
  -r requirements.txt \
  --upgrade \
  -t ${PAYLOAD_DIR}/package
#
## Build `cloud-init` using the modules from the vib payload directory
#
export PYTHONPATH="${PAYLOAD_DIR}/package"
python setup.py clean
python setup.py build
python setup.py install \
  --root ${PAYLOAD_DIR} \
  --install-scripts usr/bin \
  --install-lib usr/lib/python3.5/site-packages \
  --init-system sysvinit
