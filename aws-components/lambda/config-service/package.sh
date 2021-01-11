DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"

echo "IS Script ${PROJECT_PATH}"
source "${PROJECT_PATH}/scripts/common/utils.sh"
source "${PROJECT_PATH}/modules/module_mappings.sh"

LAMBDA_SCRIPT="config-service.py"

DEP_INCLUSIONS="logger, aws_utils"

DEP_ARR=(${DEP_INCLUSIONS//,/ })

# Init Py Virtual env
op_virtual_env "${DIR}/venv"
#
for DEP in "${DEP_ARR[@]}"
do
  clean_package "${MODULES_DIR}/${SERVICE[${DEP}]}" "${DIR}" "${DEP}"
done
##
include_and_zip "${DIR}" "${LAMBDA_SCRIPT}"