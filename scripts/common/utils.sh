#!/bin/bash

DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"

MODULES_DIR="${PROJECT_PATH}/modules"


function op_virtual_env {
  echo ${1}
  if [[ -d ${1} ]]
  then
    echo "Found active Virtual Env"
    source "${PROJECT_PATH}/venv_dep/bin/activate"
  else
    echo "Virtual Env NOT active. Creating new..."
    virtualenv "${PROJECT_PATH}/venv_dep"

    source "${PROJECT_PATH}/venv_dep/bin/activate"
  fi
}

function cls_virtual_env {
  echo "Deactivating venv"
  /bin/bash -c "deactivate; exec /bin/bash -i"
}

function packaging_message {
  echo "**********************************************"
  echo ""
  echo "   Building and installing :  "${1}
  echo ""
  echo "**********************************************"
}

function success_message {
  echo "-----------------------------------------------"
  echo "   Success :  "${1}
  echo "-----------------------------------------------"
  echo ""
}

function clean_package {
  MODULE=${1}
  TARGET_DIR=${2}
  DEP=${3}
  packaging_message "${DEP}"
  source ${MODULE}/package.sh
  cd ${MODULE}
  build_py "${TARGET_DIR}/build"
  success_message "${DEP}"
}

function include_and_zip {
  echo "zipping package"
  DIR=${1}
  INCLUDE_SRC=${2}
  cd "${DIR}/build/"
  zip -r "${DIR}/deployment_package.zip" ./* -x *.pyc -x __pycache__/ -x \*/__pycache__/ -x  -x urllib3\*/* -x six.py -x \*.dist-info/   \
     -x dateutil\*/\*  -x boto3\*/\* -x botocore\*/\* -x s3transfer\*/\* -x  jmespath\*/\* -x \*/mypy_cache/\*
  cd "${DIR}"
  zip -g "${DIR}/deployment_package.zip" "${INCLUDE_SRC}"
}