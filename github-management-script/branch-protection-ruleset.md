# GitHub Branch Protection Automation Script
This script adds a branch protection requiring lint-test to pass in order to be able to merge the changes to the main branch.

## Description
This script is designed to automate the process of setting up branch protection rules on the main branch of each public repository within a specified GitHub organization. It specifically adds a branch protection rule that requires the lint-test / build status check to pass before changes can be merged into the main branch.

## Permission required

Administration - Access: Read and write

## Usage
Run the script in a Bash-compatible shell. Ensure you have the necessary permissions on the GitHub token for the organization.

## Breakdown
The script performs three actions :
- Prompt user for token.
- Get all public repositories from the organisation.
- Apply the branch protection rule to the repository.
