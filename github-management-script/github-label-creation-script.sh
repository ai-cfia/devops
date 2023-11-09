#!/bin/bash

create_data(){
    local label_name=$1
    local label_description=$2
    local label_color=$3

    data_content="{"
    data_content+="\"name\": \"$label_name\","
    data_content+="\"description\": \"$label_description\","
    data_content+="\"color\": \"$label_color\""
    data_content+="}"

    echo "$data_content"
}

create_label(){
    ORG_NAME="ai-cfia"
    REPO_NAME=$1

    DATA=$(create_data "$LABEL_NAME" "$LABEL_DESCRIPTION" "$LABEL_COLOR")
    API_URL="https://api.github.com/repos/$ORG_NAME/$REPO_NAME/labels"

    HTTP_RESPONSE=$(curl -s -w "%{http_code}" -o response.txt -X POST \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      "$API_URL" \
      -d "$DATA")

    if [ "$HTTP_RESPONSE" -eq 201 ]; then
        echo "Label '$LABEL_NAME' created successfully in repository $REPO_NAME."
    else
        echo "Failed to create label in repository $REPO_NAME."
        cat response.txt
    fi

    rm -f response.txt
}

read -p "Enter your GitHub token: " GITHUB_TOKEN
read -p "What is the name of the label you want to create? " LABEL_NAME
read -p "Give your label a description: " LABEL_DESCRIPTION
read -p "Enter your label color (without #): " LABEL_COLOR

ORG_NAME="ai-cfia"
API_URL="https://api.github.com/orgs/$ORG_NAME/repos?type=public"
REPOS_JSON=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    "$API_URL")

REPOS=$(echo "$REPOS_JSON" | jq -r '.[] | .name')

for REPO in $REPOS; do
    echo "Creating label for $REPO"
    create_label "$REPO"
done
