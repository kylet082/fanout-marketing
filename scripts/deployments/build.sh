DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"


usage() {
  echo $'\n'" Usage : $0 stuff
  "
  exit 1
}

echo "NO"
if [ $# -eq 0 ]; then
  usage
fi

function build_workflow_comps() {
  TYPE=${1}
  PATH="workflows/${TYPE}/services/service-list.sh"
  source "${PATH}"

  for c in "${components[@]}"
  do
    /bin/bash "${PROJECT_PATH}/aws-components/lambda/${c}/package.sh"
  done
}

function build_single_comp() {
  /bin/bash "./aws-components/lambda/${1}/package.sh"
}


echo "---------------------------------------------------------"
while [[ $# -gt 0 ]];
  do
    case "${1}"
    in
    --workflow_type)
      WF_TYPE=${2}-workflow
      if [ ${WF_TYPE} != 'subscriber-workflow' ]; then
        echo "Invalid Workflow Type: " 1>2
        usage
      fi
      echo "WORKFLOW_TYPE"   ${WF_TYPE}
      shift 2
      ;;
    --component)
      COMPONENT=${2}
      echo "COMPONENT"   ${COMPONENT}
      shift 2
      ;;
    --) shift ; break ;;
    -*|--*=)
      echo "Invalid option: -${1}" >&2
      exit 1
      ;;
    esac
  done
echo "---------------------------------------------------------"


if [ -z "${COMPONENT}" ] && [ ! -z "${WF_TYPE}" ]; then
  echo "one parameter need to be set!"
  build_workflow_comps ${WF_TYPE}
elif [ ! -z "${COMPONENT}" ] && [  -z "${WF_TYPE}" ]; then
  echo "WF type builder"
  build_single_comp ${COMPONENT}
else
  echo "Error missing manditory"
fi

