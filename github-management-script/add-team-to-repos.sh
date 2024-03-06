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
    local owner=$5

    curl -s -X PUT -H "Authorization: token ${GITHUB_TOKEN}" \
        "https://api.github.com/orgs/${org}/teams/${team_slug}/repos/${owner}/${repo}" \
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
    elif [[ "${REPO}" == *db* ]]; then
        TEAM_SLUG='db'
    else
        TEAM_SLUG='devops'
    fi

    echo "Adding team \"${TEAM_SLUG}\" to repo \"${REPO}\" with permission \"${TEAM_PERMISSION}\""
    add_team_to_repo "${TEAM_SLUG}" "${ORG_NAME}" "${REPO}" "${TEAM_PERMISSION}"

    if [[ "${TEAM_SLUG}" != "${ADMIN_TEAM_SLUG}" ]]; then
        echo "Adding team \"${ADMIN_TEAM_SLUG}\" to repo \"${REPO}\" with permission \"${TEAM_PERMISSION}\""
        add_team_to_repo "${ADMIN_TEAM_SLUG}" "${ORG_NAME}" "${REPO}" "${TEAM_PERMISSION}"
    else
        echo "... Skipped adding team \"${ADMIN_TEAM_SLUG}\" as it is the same as \"${TEAM_SLUG}\""
    fi
  done

  ((PAGE++))
done
