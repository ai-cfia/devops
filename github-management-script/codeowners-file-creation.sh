#!/bin/bash
generate_codeowners() {
  repo_name=$1

  echo "# This CODEOWNERS file is auto-generated. See the script for modification details." > .github/CODEOWNERS

  # Default rules for AI-CFIA ownership for repositories which name ends with "backend", "frontend" or "db"
  if [[ ${repo_name} == *"backend" ]]; then
    echo "* @ai-cfia/backend" >> .github/CODEOWNERS
  elif [[ ${repo_name} == *"frontend" ]]; then
    echo "* @ai-cfia/frontend" >> .github/CODEOWNERS
  elif [[ ${repo_name} == *"db" ]]; then
    echo "* @ai-cfia/data" >> .github/CODEOWNERS
  fi

  {
    echo "/.github/ @ai-cfia/devops"
    echo "Dockerfile @ai-cfia/devops"
    echo "docker-compose.yml @ai-cfia/devops"
    echo "docker-compose.*.yml @ai-cfia/devops"
  } >> .github/CODEOWNERS
}

create_codeowners() {
  org_name=$1
  repo_name=$2
  codeowners_content=$(generate_codeowners "${repo_name}")

  encoded_content=$(echo "${codeowners_content}" | base64 -w 0)

  API_URL="https://api.github.com/repos/${org_name}/${repo_name}/contents/.github/CODEOWNERS"

  curl -s -X PUT \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -d "{\"message\": \"Add CODEOWNERS file\", \"content\": \"${encoded_content}\"}" \
    "${API_URL}" 
}

echo "Please enter your GitHub token:"
read -r GITHUB_TOKEN

ORG_NAME="ai-cfia"
API_URL="https://api.github.com/orgs/${ORG_NAME}/repos?type=public"
RESPONSE=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${API_URL}")
REPOS=$(echo "${RESPONSE}" | jq -r '.[].full_name')

for REPO in ${REPOS}; do
    echo "Processing repository: ${REPO}"

    create_codeowners "$(dirname "${REPO}") $(basename "${REPO}")"

done