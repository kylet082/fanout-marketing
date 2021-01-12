DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"


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
        --version               :   For development usage. Defaults from project version file.
        --state_bucket          :   Options [ 's3', 'local' ]. For development usage. Where to upload ft states file

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
    --version)
      VERSION=${2}
      echo "VERSION"   ${VERSION}
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

if [ ! "$WF_TYPE" ] || [ ! "$WF_NAME" ] || [ ! "$CODE_BUCKET" ]; then
    echo "One or more mandatory parameters missing!"
    usage
fi

if [ ! "$VERSION" ]; then
  VERSION=$(head -n 1 ./project.version )
fi

if [ ! "$STATE_BUCKET" ]; then
  STATE_BUCKET="s3"
elif [ "$STATE_BUCKET" != "local" ] && [ "$STATE_BUCKET" != "s3" ]; then
  echo "State Bucket has invalid option"
  usage
fi


echo "Project Version: ${VERSION}"

echo "-----------------------------------------------------------"
echo "                Building Components "
source ${PROJECT_PATH}/workflows/${WF_TYPE}/services/build.sh
echo "                 Completed !"
echo "-----------------------------------------------------------"

if [ ${STATE_BUCKET} == "local" ]; then
  TF_BACKEND_TEMPLATE=terraform/base/backend-template/backend.tf
  PATTERN="s/AWS_REGION/${AWS_REGION}/g"
fi
if [ ${STATE_BUCKET} == "s3" ]; then
  TF_BACKEND_TEMPLATE=terraform/base/backend-template/backend-s3.tf
  PATTERN="s/AWS_REGION/${AWS_REGION}/g;s/CODE_BUCKET/${CODE_BUCKET}/g;s/WF_TYPE/${WF_TYPE}/g;s/WF_NAME/${WF_NAME}/g;"
fi

echo "Applying pattern ${PATTERN} to ${TF_BACKEND_TEMPLATE}"
sed ${PATTERN} < ${TF_BACKEND_TEMPLATE} > workflows/${WF_TYPE}/backend.tf

cd ./workflows/${WF_TYPE}

terraform get
terraform init
terraform apply -auto-approve=true \
  -var "workflow_name=${WORKLFLOW_NAME}" \
  -var "s3_code_bucket=${CODE_BUCKET}" \
  -var "project_version=${VERSION}" \
  -var "tags={workflow_type=\"${WF_TYPE}\",version=\"${VERSION}\"}"