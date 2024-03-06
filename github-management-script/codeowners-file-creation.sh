#!/bin/bash
generate_codeowners() {
  local repo_name=$1
  local content=""

  content+="# This CODEOWNERS file is auto-generated. See the script at <https://github.com/ai-cfia/devops/blob/main/github-management-script/codeowners-file-creation.sh> for modification details.\n\n"

  if [[ ${repo_name} == *"backend"* ]]; then
    content+="* @ai-cfia/backend\n"
  elif [[ ${repo_name} == *"frontend"* ]]; then
    content+="* @ai-cfia/frontend\n"
  elif [[ ${repo_name} == *"db"* ]]; then
    content+="* @ai-cfia/data\n"
  fi

  content+="/.github/ @ai-cfia/devops\n"
  content+="Dockerfile @ai-cfia/devops\n"
  content+="docker-compose.yml @ai-cfia/devops\n"
  content+="docker-compose.*.yml @ai-cfia/devops\n"

  printf "%b" "${content}"
}

create_codeowners() {
  local org_name=$1
  local repo_name=$2
  local codeowners_content
  codeowners_content="$(generate_codeowners "${repo_name}")"
  codeowners_content+=$'\n'
  
  local API_URL="https://api.github.com/repos/${org_name}/${repo_name}/contents/.github/CODEOWNERS"

  # Extract the SHA from the response, if the file exists. Common requirement 
  # when updating an existing file in a repository.
  local response
  response=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" "${API_URL}")
  local sha
  sha=$(echo "${response}" | jq -r '.sha // empty')

  local encoded_content
  encoded_content=$(printf "%b" "${codeowners_content}" | base64 -w 0)

  local json_data
  if [[ -n "${sha}" ]]; then
    # If the file exists, include the SHA in the request to update it
    json_data="{\"message\": \"Update CODEOWNERS file with EOF line\", \"content\": \"${encoded_content}\", \"sha\": \"${sha}\"}"
  else
    # If the file doesn't exist, the SHA is not required
    json_data="{\"message\": \"Add CODEOWNERS file\", \"content\": \"${encoded_content}\"}"
  fi

  curl -s -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -d "${json_data}" \
    "${API_URL}"
}

echo "Please enter your GitHub token:"
read -r GITHUB_TOKEN

ORG_NAME="ai-cfia"
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
    echo "Processing repository: ${REPO}"
    create_codeowners "${ORG_NAME}" "$(basename "${REPO}")"
  done

  ((PAGE++))
done
