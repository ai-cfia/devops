#!/bin/bash

ORG_NAME='ai-cfia'
TEAM_PERMISSION='push' # 'pull' or 'push' or 'admin'
ADMIN_TEAM_SLUG='devops'

echo "Please enter your GitHub access token:"
read -r GITHUB_TOKEN

add_team_to_repo() {
    local team_slug=$1
    local org=$2
    local repo=$3
    local permission=$4
    curl -L \
        -X PUT \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/orgs/${org}/teams/${team_slug}/repos/${repo}" \
        -d "{\"permission\":\"${permission}\"}"
}

PAGE=1
PER_PAGE=100

while :; do
  API_URL="https://api.github.com/orgs/${ORG_NAME}/repos?type=public&per_page=${PER_PAGE}&page=${PAGE}"

  RESPONSE=$(curl -s -H "Accept: application/vnd.github+json" \
                    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                    "${API_URL}")

  REPOS=$(echo "${RESPONSE}" | jq -r '.[].full_name')
  
  if [[ -z "${REPOS}" ]]; then
    break
  fi

  for REPO in ${REPOS}; do
    if [[ "${REPO}" == *backend* ]]; then
        TEAM_SLUG='backend'
    elif [[ "${REPO}" == *frontend* ]]; then
        TEAM_SLUG='frontend'
    fi

    if [[ "${REPO}" == *db* ]] || [[ "${REPO}" == *data* ]]; then
        TEAM_SLUG='data'
    fi

    if [[ "${REPO}" == *nachet* ]]; then
        PRODUCT_SLUG='nachet'
    elif [[ "${REPO}" == *finesse* ]]; then
        PRODUCT_SLUG='finesse'
    elif [[ "${REPO}" == *harvester* ]]; then
        PRODUCT_SLUG='harvester'     
    fi

    if [[ "${TEAM_SLUG}" != '' ]]; then
        echo "Adding team \"${TEAM_SLUG}\" to repo \"${REPO}\" with permission \"${TEAM_PERMISSION}\""
        add_team_to_repo "${TEAM_SLUG}" "${ORG_NAME}" "${REPO}" "${TEAM_PERMISSION}"

        if [[ "${TEAM_SLUG}" != "${ADMIN_TEAM_SLUG}" ]]; then
            echo "Adding team \"${ADMIN_TEAM_SLUG}\" to repo \"${REPO}\" with permission \"${TEAM_PERMISSION}\""
            add_team_to_repo "${ADMIN_TEAM_SLUG}" "${ORG_NAME}" "${REPO}" "${TEAM_PERMISSION}"
        else
            echo "... Skipped adding team \"${ADMIN_TEAM_SLUG}\" as it is the same as \"${TEAM_SLUG}\""
        fi
    else
        echo "Skipping.. No team found for repo \"${REPO}\""
    fi

    if [[ "${PRODUCT_SLUG}" != '' ]]; then
        echo "Adding product team \"${PRODUCT_SLUG}\" to repo \"${REPO}\" with permission \"${TEAM_PERMISSION}\""
        add_team_to_repo "${PRODUCT_SLUG}" "${ORG_NAME}" "${REPO}" "${TEAM_PERMISSION}"
    else
        echo "Skipping.. No product team found for repo \"${REPO}\""
    fi

    echo "Adding team devops to repo \"${REPO}\" with permission \"${TEAM_PERMISSION}\""
    add_team_to_repo "devops" "${ORG_NAME}" "${REPO}" "${TEAM_PERMISSION}"

    TEAM_SLUG=''
    PRODUCT_SLUG=''
  done

  ((PAGE++))
done
