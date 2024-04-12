# CODEOWNERS Automation Script

This script automates the creation of CODEOWNERS files within repositories of
the CFIA organization and applies tag rules based on repository names.

## Functionality

* **Creates CODEOWNERS Files:**  The script generates CODEOWNERS files in target
  repositories, defining code ownership rules to streamline the review process.
* **Customizable Team Tagging:** It tags relevant teams (`backend`, `frontend`,
  `data`, `devops`, `finesse`, `harvester`, `nachet`) based on the repository
  name.
* **DevOps Ownership:** The script assigns specific ownership to the DevOps team
  for files within the `.github` directory, Dockerfile, and docker-compose
  configurations.

## Requirements

* **GitHub Personal Access Token (PAT):** A PAT with the `repo` scope.

## Usage

1. **Set Environment Variables:**
    1. `GITHUB_TOKEN`:  Store your GitHub PAT in this environment variable. 
    2. `ORG_NAME`: Set this to the name of your target GitHub organization.
2. **Execute the Script:** Run the script. It will:
    1. Prompt for your GitHub token (if not set).
    2. Retrieve a list of repositories within the organization.
    3. Process each repository, generating and adding the CODEOWNERS file.
