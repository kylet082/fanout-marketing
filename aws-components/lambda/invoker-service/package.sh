DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"

source "${PROJECT_PATH}/scripts/common/utils.sh"
source "${PROJECT_PATH}/modules/module_mappings.sh"

SERVICE_HOME="${PROJECT_PATH}/aws-components/lambda/invoker-service"

LAMBDA_SCRIPT="invoker-service.py"

DEP_INCLUSIONS="logger"

DEP_ARR=(${DEP_INCLUSIONS//,/ })

component_message "Invoker-Service"

# Init Py Virtual env
op_virtual_env "${PROJECT_PATH}/venv_dep"
#
for DEP in "${DEP_ARR[@]}"
do
  clean_package "${MODULES_DIR}/${SERVICE[${DEP}]}" "${SERVICE_HOME}" "${DEP}"
done
##
include_and_zip "${PROJECT_PATH}/aws-components/lambda/invoker-service" "${LAMBDA_SCRIPT}"