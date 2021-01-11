SCRIPT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

MODULES_DIR=$( cd "${SCRIPT_ROOT}/../../modules" && pwd)
MODULES_MAPPINGS="$( cd "${SCRIPT_ROOT}/../../modules/" && pwd)/module_mappings.sh"

ROOT=$( cd "${SCRIPT_ROOT}/../.." && pwd)

function op_virtual_env {
  if [[ "$VIRTUAL_ENV" != "" ]]
  then
    echo "Found active Virtual Env"
  else
    echo "Virtual Env NOT active. Creating new..."
    virtualenv "${ROOT}/venv_dep"

    /bin/bash -c ". ${ROOT}/venv_dep/bin/activate; exec /bin/bash -i"
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