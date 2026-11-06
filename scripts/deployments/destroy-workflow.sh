DIR=$( pwd )
PROJECT_PATH="$(git rev-parse --show-toplevel)"

set -e

AWS_REGION="eu-west-1"

usage() {
  echo $'\n'" Usage : $0 --workflow_type {workflow_type} --workflow_name {workflow_name} --code_bucket {code_bucket}
     --aws_region {aws_region} --version {project_version}

     Mandatory Parameters:
        --workflow_type         :   Workflow type supported options [ 'subscriber' ]
        --workflow_name         :   Unique name for the workflow
        --code_bucket           :   s3 location for configurations

    Optional Parameters:
        --aws_region            :   Defaults ['eu-west-1'] - AWS region for the deployment

   "
   exit 1;
}

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
    --workflow_name)
      WF_NAME=${2}
      echo "WORKFLOW_NAME"   ${WF_NAME}
      shift 2
      ;;
    --code_bucket)
      CODE_BUCKET=${2}
      echo "CODE_BUCKET"   ${CODE_BUCKET}
      shift 2
      ;;
    --state_bucket)
      STATE_BUCKET=${2}
      echo "STATE_BUCKET"   ${STATE_BUCKET}
      shift 2
      ;;
    --aws_region)
      AWS_REGION=${2}
      echo "AWS_REGION"   ${AWS_REGION}
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

if [ ! "$STATE_BUCKET" ]; then
  STATE_BUCKET="s3"
elif [ "$STATE_BUCKET" != "local" ] && [ "$STATE_BUCKET" != "s3" ]; then
  echo "State Bucket has invalid option"
  usage
fi


BACKEND_FILES=$( aws s3api list-objects-v2 --bucket ${STATE_BUCKET} --prefix ${WF_TYPE}/${WF_NAME}/terraform/state --query 'Contents[].Key' --output text )
# collect all the aws secrets to be destroyed here as well.

# destroy all workflow states
echo "__________________________________________"
echo ""
echo " Destroying Terraform managed Resources "
echo ""
echo "__________________________________________"
for i in ${BACKEND_FILES}
do
    cat > ${PROJECT_PATH}/zmisc/backend.tf << EOF
provider "aws" {
  region = "${AWS_REGION}"
}
terraform {
  backend "s3" {
    bucket = "${CODE_BUCKET}"
    key    = "${i}"
    region = "${AWS_REGION}"
    encrypt = true
  }
}
EOF
  echo "${BACKEND_FILES}"

  cd ${PROJECT_PATH}/zmisc
  cat backend.tf
  terraform init
  terraform refresh
  terraform destroy -auto-approve
done


if [ "${WF_TYPE}" == "subscriber-workflow" ]; then
  echo "__________________________________________"
  echo ""
  echo " Destroying Subscriber Single Resources "
  echo ""
  echo "__________________________________________"
  SECRETS_NAMES="${WF_NAME}/subscriber"

  SECRETS=$( aws secretsmanager list-secrets --filters Key=name,Values="${SECRETS_NAMES}" --query 'SecretList[].Name' --output text )

  for s in ${SECRETS}
  do
    echo "Attempting Secrets Deletion : ${s}"
    aws secretsmanager delete-secret --secret-id "${s}" --force-delete-without-recovery
  done
fi

echo " Completed !"