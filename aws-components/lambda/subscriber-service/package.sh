DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source "$DIR/../../../scripts/common/utils.sh"
source "${MODULES_MAPPINGS}"

LAMBDA_SCRIPT="subscriber-service.py"

DEP_INCLUSIONS="logger,aws_utils,sendmode,mailchimp"

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