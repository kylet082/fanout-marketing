#!/bin/bash
DIR=$( pwd )
PROJECT_PATH="$(git rev-parse --show-toplevel)"

source "${PROJECT_PATH}/scripts/common/utils.sh"
source "${PROJECT_PATH}/modules/module_mappings.sh"

SERVICE_HOME="${PROJECT_PATH}/aws-components/lambda/config-service"

LAMBDA_SCRIPT="config-service.py"

DEP_INCLUSIONS="logger, aws_utils"

DEP_ARR=(${DEP_INCLUSIONS//,/ })

component_message "Config-Service"


# Init Py Virtual env
op_virtual_env "${PROJECT_PATH}/venv_dep"
##
for DEP in "${DEP_ARR[@]}"
do
  clean_package "${MODULES_DIR}/${SERVICE[${DEP}]}" "${SERVICE_HOME}" "${DEP}"
done

include_and_zip "${SERVICE_HOME}" "${LAMBDA_SCRIPT}"