#!/bin/bash
# A list for all the Components that need to be
# built and packaged for deployment
#
DIR=$( pwd )
PROJECT_PATH="$(git rev-parse --show-toplevel)"


source "${PROJECT_PATH}/aws-components/lambda/config-service/package.sh"
source "${PROJECT_PATH}/aws-components/lambda/invoker-service/package.sh"
source "${PROJECT_PATH}/aws-components/lambda/notification-service/package.sh"
source "${PROJECT_PATH}/aws-components/lambda/subscriber-service/package.sh"
