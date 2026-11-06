#!/bin/bash
DIR=$( pwd )
PROJECT_PATH="$(git rev-parse --show-toplevel)"

set -e

AWS_REGION="eu-west-1"

usage() {
  echo $'\n'" Usage : $0  --workflow_type subscriber --company_name {company_name} \
        --workflow_name {workflow_name} --mailchimp_audience_id {audience ID} \\
        --sendmode_group {group ID} --code_bucket {code bucket}

     Mandatory Parameters:
        --workflow_type         :   Workflow type supported options [ 'subscriber' ]
        --workflow_name         :   Unique name for the workflow
        --mailchimp_audience_id :   Mailchimp audience to add subscribers to
        --sendmode_group        :   SendMode group to add subscribers to
        --company_name          :   Client key used in config.json and the secret name
        --code_bucket           :   s3 location for configurations

    Optional Parameters:
        --aws_region            :   Defaults ['eu-west-1'] - AWS region for the deployment
        --version               :   For development usage. Defaults from project version file.

    API keys:
        API keys are never passed as arguments, so they stay out of shell history and the process list.
        Set MAILCHIMP_KEY and SENDMODE_KEY in the environment, or leave them unset to be prompted
        (input is hidden).

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
    --mailchimp_key|--sendmode_key)
      echo "${1} is no longer supported: API keys must not be passed as arguments." >&2
      echo "Set MAILCHIMP_KEY / SENDMODE_KEY in the environment, or leave them unset to be prompted." >&2
      exit 1
      ;;
    --mailchimp_audience_id)
      MAILCHIMP_ID=${2}
      echo "MAILCHIMP_ID"   ${MAILCHIMP_ID}
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

# Read API keys from the environment, or prompt without echoing them.
if [ -z "${MAILCHIMP_KEY}" ]; then
  read -r -s -p "Mailchimp API key: " MAILCHIMP_KEY; echo
fi
if [ -z "${SENDMODE_KEY}" ]; then
  read -r -s -p "SendMode API key: " SENDMODE_KEY; echo
fi
if [ -z "${MAILCHIMP_KEY}" ] || [ -z "${SENDMODE_KEY}" ]; then
  echo "Both a Mailchimp and a SendMode API key are required." >&2
  exit 1
fi

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
SECRET_NAME="${WF_NAME}/subscriber/${COMPANY}"

echo "Config Location : ${S3_KEY}"
python3 ${PROJECT_PATH}/scripts/common/config_update.py --mailchimp_id "${MAILCHIMP_ID}" --sendmode_group "${SENDMODE_GROUP}" --company_name "${COMPANY}" \
  --s3_bucket "${CODE_BUCKET}" --s3_key "${S3_KEY}" --aws_secret_name "${SECRET_NAME}"


echo "Creating AWS Secret for Company:  ${COMPANY}"
# Write the secret to a private temp file (mktemp creates it as 0600) and pass it by path,
# so the keys never appear on a command line. The file is removed when the script exits.
SECRET_FILE=$(mktemp)
trap 'rm -f "${SECRET_FILE}"' EXIT
MAILCHIMP_KEY="${MAILCHIMP_KEY}" SENDMODE_KEY="${SENDMODE_KEY}" python3 -c '
import json, os, sys
json.dump({"sendmode_key": os.environ["SENDMODE_KEY"], "mailchimp_key": os.environ["MAILCHIMP_KEY"]}, sys.stdout)
' > "${SECRET_FILE}"

aws secretsmanager create-secret --name "${SECRET_NAME}" --secret-string "file://${SECRET_FILE}"


#python3 ${PROJECT_PATH}/scripts/common/config_update.py --mailchimp_id 12 --sendmode_group bd100 --company_name acme_beauty --s3_bucket kgt-dev-code --s3_key subscriber-workflow/optin-v2/config/config.json --aws_secret_name t/t/t