#!/bin/bash
source .env

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

echo -e "\n Creating cache DB with name ${JUICE_LOCAL_NAME} \n"
juicefs format sqlite3://${JUICE_LOCAL_NAME}.db ${JUICE_LOCAL_NAME}


echo -e "\nMounting cache at path ${JUICE_LOCAL_PATH} \n"
juicefs mount sqlite3://${JUICE_LOCAL_NAME}.db $JUICE_LOCAL_PATH || \
echo -e "\n A local storage file for JUICE_LOCAL_NAME=$JUICE_LOCAL_NAME already exists \n" && \
echo -e "Either change JUICE_LOCAL_NAME=$JUICE_LOCAL_NAME or delete $HOME/.juicefs/local/$JUICE_LOCAL_NAME " \