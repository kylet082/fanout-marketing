echo "fasfa"

usage() {
  echo $'\n'" Usage : $0 stuff
  "
  exit 1
}

echo "NO"
if [ $# -eq 0 ]; then
  usage
fi



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
    --) shift ; break ;;
    -*|--*=)
      echo "Invalid option: -${1}" >&2
      exit 1
      ;;
    esac
  done
echo "---------------------------------------------------------"

PATH="workflows/${WF_TYPE}/services/service-list.sh"

source "${PATH}"

for comp in "${components[@]}"
do
  a=$(pwd)
  echo $a
  /bin/bash "./aws-components/lambda/${comp}/package.sh"
done