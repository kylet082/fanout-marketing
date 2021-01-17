DIR=$( pwd )
SPLIT_PATH=(${DIR//\/EnterpriseService_v2/ })
PROJECT_PATH="${SPLIT_PATH[0]}/EnterpriseService_v2"

set -e

AWS_REGION="eu-west-1"

usage() {
  echo $'\n'" Usage : $0  --workflow_type subscriber --company_name {company_name} \
        --workflow_name {workflow_name} --mailchimp_key {api_key} --mailchimp_audience_id {audeince ID} \\
        --sendmode_key {api key} --sendmode_group {group ID} --code_bucket {code bucket}

     Mandatory Parameters:
        --workflow_type         :   Workflow type supported options [ 'subscriber' ]
        --workflow_name         :   Unique name for the workflow
        --mailchimp_key         :
        --mailchimp_audience_id :
        --sendmode_key          :
        --sendmode_group        :
        --company_name          :
        --code_bucket           :   s3 location for configurations

    Optional Parameters:
        --aws_region            :   Defaults ['eu-west-1'] - AWS region for the deployment
        --version               :   For development usage. Defaults from project version file.

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
    --company_name)
      COMPANY=${2}
      echo "COMPANY"   ${COMPANY}
      shift 2
      ;;
    --workflow_name)
      WF_NAME=${2}
      echo "WORKFLOW_NAME"   ${WF_NAME}
      shift 2
      ;;
    --mailchimp_key)
      MAILCHIMP_KEY=${2}
      echo "MAILCHIMP_KEY"   ${MAILCHIMP_KEY}
      shift 2
      ;;
    --mailchimp_audience_id)
      MAILCHIMP_ID=${2}
      echo "MAILCHIMP_ID"   ${MAILCHIMP_ID}
      shift 2
      ;;
    --sendmode_key)
      SENDMODE_KEY=${2}
      echo "SENDMODE_KEY"   ${SENDMODE_KEY}
      shift 2
      ;;
    --sendmode_group)
      SENDMODE_GROUP=${2}
      echo "SENDMODE_GROUP"   ${SENDMODE_GROUP}
      shift 2
      ;;
    --code_bucket)
      CODE_BUCKET=${2}
      echo "CODE_BUCKET"   ${CODE_BUCKET}
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


#if [ ! "$WF_TYPE" ] || [ ! "$WF_NAME" ] || [ ! "$CODE_BUCKET" ] || [ ! "${MAILCHIMP_KEY}" ] || [ ! "${SENDMODE_KEY}" ] ; then
#    echo "One or more mandatory parameters missing!"
#    usage
#fi

if [ ! "$VERSION" ]; then
  VERSION=$(head -n 1 ./project.version )
fi

echo "Project Version: ${VERSION}"

echo "Adding Configuration details to the workflow : ${WF_NAME}"

S3_KEY="${WF_TYPE}/${WF_NAME}/config/config.json"
python3 ${PROJECT_PATH}/scripts/common/config_update.py --mailchimp_id "${MAILCHIMP_ID}" --sendmode_group "${SENDMODE_GROUP}" --company_name "${COMPANY}" \
  --s3_bucket "${CODE_BUCKET}" --s3_key "${S3_KEY}" --aws_secret_name "${SECRET_NAME}"


echo "Creating AWS Secret for Company:  ${COMPANY}"
SECRET_STRING_PATTERN='{"sendmode_key":"SENDMODE","mailchimp_key":"MAILCHIMP"}'
SECRET_STRING=$(echo ${SECRET_STRING_PATTERN} | sed "s/SENDMODE/${SENDMODE_KEY}/g;s/MAILCHIMP/${MAILCHIMP_KEY}/g")
SECRET_NAME="${WF_NAME}/subscriber/${COMPANY}"

aws secretsmanager create-secret --name ${SECRET_NAME} --secret-string ${SECRET_STRING}


#python3 ${PROJECT_PATH}/scripts/common/config_update.py --mailchimp_id 12 --sendmode_group bd100 --company_name acme_beauty --s3_bucket kgt-dev-code --s3_key subscriber-workflow/optin-v2/config/config.json --aws_secret_name t/t/t