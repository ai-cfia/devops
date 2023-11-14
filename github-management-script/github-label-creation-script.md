# GitHub Label Creation Automation Script

## Description
The script is designed to automate the creation of GitHub labels in each public repository of the organization. Doing it through GitHub dashboard doesn't add the new label to the existing repositories so this script was created to do that.

## Permission required

Issues - Access: Read and write

## Usage
Run the script `bach github-label-creation-script.sh`. You will need need to provid the GitHub token, label name, label description and label colour. You can pick a color [here](https://colors-picker.com/hex-color-picker/)

Breakdown
The script performs the following actions:

- Prompts the user for their GitHub token and label details (name, description, color).
- Fetches all public repositories from the organization.
- Creates the label in each repository.
