DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "IS Script ${DIR}"
source "$DIR/scripts/common/utils.sh"
source "${MODULES_MAPPINGS}"

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