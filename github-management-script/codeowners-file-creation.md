# 🎯 Script: Global CODEOWNERS Create/Update with `@ai-cfia/ai-lab-team`

## Purpose

This script automates the creation or update of the `.github/CODEOWNERS` file in **all public and private repositories** within the GitHub organization `ai-cfia`.

Each target repository will receive a `CODEOWNERS` file with **a single rule**:

```
# This CODEOWNERS file is auto-generated. See the script at <https://github.com/ai-cfia/devops/blob/main/github-management-script/codeowners-file-creation.sh> for modification details.

* @ai-cfia/ai-lab-team
```

Any existing CODEOWNERS configuration will be replaced, assigning full code ownership to the `@ai-cfia/ai-lab-team`.

---

## How It Works

1. Prompts the user for a **GitHub Personal Access Token** (entered securely).
2. Retrieves all repositories from the organization (`type=all`, includes public and private).
3. For each repository:
   - Checks if a `.github/CODEOWNERS` file exists.
   - If it exists, it is **overwritten**.
   - If it does not exist, it is **created**.
4. The update is performed via the GitHub REST API using the `PUT /repos/:org/:repo/contents/.github/CODEOWNERS` endpoint.

---

## Requirements

- A GitHub **Personal Access Token** (`GITHUB_TOKEN`) with the following scopes:
  - `repo`
  - `contents:write` (included in `repo`)
- The `jq` CLI tool installed:
  - Ubuntu/Debian: `sudo apt install jq`
  - macOS: `brew install jq`
- Standard CLI tools: `bash`, `curl`, `base64`

---

## Usage

```bash
chmod +x codeowners-file-creation.sh
./codeowners-file-creation.sh
```

The script will prompt for your GitHub token (it is hidden during input).

---

## Example Output

```
Please enter your GitHub token:
📦 Updating CODEOWNERS for project-alpha
📦 Updating CODEOWNERS for backend-service
📦 Updating CODEOWNERS for frontend-template
```

---

## Recommended Repository Structure

Store the script and this documentation in a central DevOps repository:

```
devops/
└── github-management-script/
    ├── codeowners-file-creation.sh
    └── codeowners-file-creation.md
```

---

## ⚠️ Warning

This script **overwrites any existing CODEOWNERS file**.  
If you have a customized ownership setup by directory or team, it will be removed.

It is strongly recommended to:
- Test on a single repository first.
- Back up your existing CODEOWNERS rules if needed.

---

## Source

[View the script `codeowners-file-creation.sh`](https://github.com/ai-cfia/devops/blob/main/github-management-script/codeowners-file-creation.sh)
