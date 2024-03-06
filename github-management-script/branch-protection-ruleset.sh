#!/bin/bash

echo "Please enter your GitHub token:"
read -r GITHUB_TOKEN

ORG_NAME="ai-cfia"
PAGE=1
PER_PAGE=100
REPOS=""

while :; do
    API_URL="https://api.github.com/orgs/${ORG_NAME}/repos?type=public&per_page=${PER_PAGE}&page=${PAGE}"

    RESPONSE=$(curl -s -H "Accept: application/vnd.github+json" \
                      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                      "${API_URL}")

    CURRENT_PAGE_REPOS=$(echo "${RESPONSE}" | jq -r '.[].full_name')
    
    if [[ -z "${CURRENT_PAGE_REPOS}" ]]; then
        break
    else
        REPOS="${REPOS} ${CURRENT_PAGE_REPOS}"
        ((PAGE++))
    fi
done

# Trim leading whitespace
REPOS=$(echo "${REPOS}" | xargs)

set_branch_protection() {
    REPO_NAME=$1
    BRANCH_NAME="main"

    API_URL="https://api.github.com/repos/${REPO_NAME}/branches/${BRANCH_NAME}/protection"

    DATA='{
        "required_status_checks": null,
        "enforce_admins": true,
        "required_pull_request_reviews": {
            "required_approving_review_count": 1,
            "require_code_owner_reviews": true
        },
        "restrictions": null
    }'

    curl -L \
        -X PUT \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${API_URL}" \
        -d "${DATA}"
}

# for each repo, check if .github/workflows exists
for REPO in ${REPOS}; do
    WORKFLOWS_URL="https://api.github.com/repos/${REPO}/contents/.github/workflows"
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${WORKFLOWS_URL}")

    # if the http response code is 200, the directory exists
    if [[ "${RESPONSE}" -eq 200 ]]; then
        echo "Setting branch protection rules for ${REPO}"
        set_branch_protection "${REPO}"
    fi
done
