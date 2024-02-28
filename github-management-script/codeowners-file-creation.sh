#!/bin/bash
generate_codeowners() {
  repo_name=$1

  echo "# This CODEOWNERS file is auto-generated. See the script for modification details." > .github/CODEOWNERS

  # Default rules for AI-CFIA ownership for repositories which name ends with "backend", "frontend" or "db"
  if [[ $repo_name == *"backend" ]]; then
    echo "* @ai-cfia/backend" >> .github/CODEOWNERS
  elif [[ $repo_name == *"frontend" ]]; then
    echo "* @ai-cfia/frontend" >> .github/CODEOWNERS
  elif [[ $repo_name == *"db" ]]; then
    echo "* @ai-cfia/data" >> .github/CODEOWNERS
  fi

  # Specific rules for DevOps ownership
  echo "/.github/ @ai-cfia/devops" >> .github/CODEOWNERS
  echo "Dockerfile @ai-cfia/devops" >> .github/CODEOWNERS
  echo "docker-compose.yml @ai-cfia/devops" >> .github/CODEOWNERS
  echo "docker-compose.*.yml @ai-cfia/devops" >> .github/CODEOWNERS
}

echo "Please enter your GitHub token:"
read GITHUB_TOKEN

ORG_NAME="ai-cfia"

API_URL="https://api.github.com/orgs/${ORG_NAME}/repos?type=public"
REPOS=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${API_URL}" | jq -r '.[].full_name')

for REPO in ${REPOS}; do
    echo "Processing repository: ${REPO}"

    # Create CODEOWNERS file
    generate_codeowners $(basename -s .git $REPO) 

    git add .github/CODEOWNERS
    git commit -m "Add CODEOWNERS file"
    git push origin HEAD 
done