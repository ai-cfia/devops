#!/bin/bash

# prompt for GitHub token
echo "Please enter your GitHub token:"
read GITHUB_TOKEN

ORG_NAME="ai-cfia"

API_URL="https://api.github.com/orgs/${ORG_NAME}/repos?type=public"

# get list of all public repos
REPOS=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${API_URL}" | jq -r '.[].full_name')

set_branch_protection() {
    REPO_NAME=$1
    BRANCH_NAME="main"

    API_URL="https://api.github.com/repos/${REPO_NAME}/branches/${BRANCH_NAME}/protection"

    DATA='{
        "required_status_checks": {
            "strict": true,
            "contexts": ["lint-test / build"]
        },
        "enforce_admins": true,
        "required_pull_request_reviews": {
            "required_approving_review_count": 1
        },
        "restrictions": null
    }'

    curl -L \
        -X PUT \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${API_URL}" \
        -d "${DATA}"
}

# remove_branch_protection() {
#     REPO_NAME=$1
#     BRANCH_NAME="main"

#     API_URL="https://api.github.com/repos/${REPO_NAME}/branches/${BRANCH_NAME}/protection"

#     curl -L \
#         -X DELETE \
#         -H "Accept: application/vnd.github.v3+json" \
#         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
#         "${API_URL}"
# }

# for each repo, check if .github/workflows exists
for REPO in ${REPOS}; do
    WORKFLOWS_URL="https://api.github.com/repos/${REPO}/contents/.github/workflows"
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${WORKFLOWS_URL}")

    # if the http response code is 200, the directory exists
    if [ "${RESPONSE}" -eq 200 ]; then
        echo "Setting branch protection rules for ${REPO}"
        set_branch_protection ${REPO}
    fi
done
