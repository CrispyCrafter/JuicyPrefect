#!/bin/bash
source .env

context=${1:-local}
while getopts c: flag
do
    case "${flag}" in
        c) context=${OPTARG};;
    esac
done

resolve_deps() {
    if [[ $(type -P "$1") ]]
    then 
        echo "Found $1 in PATH"
    else 
       echo "$1 is NOT in PATH" 1>&2
       echo "Please see $2 for instuctions" 
       if [[ "$OSTYPE" == "darwin"* ]] 
       then
            echo "Also install MacFUSE via brew install macfuse"
        fi
       exit 1
    fi
} 

# Resolve dependencies
resolve_deps juicefs "https://juicefs.com/docs/community/installation/"

echo $context

if [ $context == "s3" ]
then
    echo -e "\n Creating S3 cache DB with name ${JUICE_LOCAL_NAME}\n"
    juicefs format --storage s3 \
        --bucket $AWS_BUCKET_PATH \
        --access-key $AWS_ACCESS_KEY_ID \
        --secret-key $AWS_SECRET_ACCESS_KEY \
        --session-token $AWS_SESSION_TOKEN \
        ${JUICE_CONNECTION_URL} ${JUICE_LOCAL_NAME}
else
    echo -e "\n Creating Local cache DB with name ${JUICE_LOCAL_NAME}\n"
    juicefs format ${JUICE_CONNECTION_URL} ${JUICE_LOCAL_NAME}
fi

echo -e "\nMounting cache at path ${JUICE_LOCAL_PATH} \n"
juicefs mount ${JUICE_CONNECTION_URL} $JUICE_LOCAL_PATH || \
echo -e "\n A local storage file for JUICE_LOCAL_NAME=$JUICE_LOCAL_NAME already exists \n" && \
echo -e "Either change JUICE_LOCAL_NAME=$JUICE_LOCAL_NAME or delete $HOME/.juicefs/local/$JUICE_LOCAL_NAME " 