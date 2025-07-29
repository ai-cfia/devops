#!/bin/bash

# 🧠 Génère un CODEOWNERS minimal avec ai-lab-team
generate_codeowners() {
  printf "%s\n\n%s\n" \
    "# This CODEOWNERS file is auto-generated. See the script at <https://github.com/ai-cfia/devops/blob/main/github-management-script/codeowners-file-creation.sh> for modification details." \
    "* @ai-cfia/ai-lab-team"
}

# 📤 Crée ou met à jour le fichier CODEOWNERS via l'API GitHub
create_codeowners() {
  local org_name=$1
  local repo_name=$2
  local codeowners_content
  codeowners_content="$(generate_codeowners)"
  codeowners_content+=$'\n'

  local API_URL="https://api.github.com/repos/${org_name}/${repo_name}/contents/.github/CODEOWNERS"

  # 🔍 Vérifie si le fichier existe déjà pour obtenir le SHA
  local response
  response=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" "${API_URL}")
  local sha
  sha=$(echo "${response}" | jq -r '.sha // empty')

  # 🔐 Encodage base64 compatible Linux/macOS
  local encoded_content
  encoded_content=$(printf "%s" "${codeowners_content}" | base64 | tr -d '\n')

  local json_data
  if [[ -n "${sha}" ]]; then
    json_data="{\"message\": \"Update CODEOWNERS file\", \"content\": \"${encoded_content}\", \"sha\": \"${sha}\"}"
  else
    json_data="{\"message\": \"Add CODEOWNERS file\", \"content\": \"${encoded_content}\"}"
  fi

  echo "📦 Updating CODEOWNERS for ${repo_name}..."
  curl -s -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -d "${json_data}" \
    "${API_URL}" > /dev/null
}

# 🔐 Demande du token GitHub en mode sécurisé
echo "Please enter your GitHub token:"
read -s GITHUB_TOKEN

ORG_NAME="ai-cfia"
PAGE=1
PER_PAGE=100

while :; do
  API_URL="https://api.github.com/orgs/${ORG_NAME}/repos?type=all&per_page=${PER_PAGE}&page=${PAGE}"
  RESPONSE=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" "${API_URL}")

  REPOS=$(echo "${RESPONSE}" | jq -r '.[].name')

  if [[ -z "${REPOS}" || "${REPOS}" == "null" ]]; then
    break
  fi

  for REPO in ${REPOS}; do
    create_codeowners "${ORG_NAME}" "${REPO}"
    sleep 1
  done

  ((PAGE++))
done
