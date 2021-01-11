# A list for all the Components that need to be
# built and packaged for deployment
#

DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"

#declare -a components=(
#  "config-service"
##  "invoker-service"
##  "notification-service"
##  "subscriber-service"
#)

source "${PROJECT_PATH}/aws-components/lambda/config-service/package.sh"
