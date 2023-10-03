#!/bin/bash

# Function to repeatedly prompt the user until input is provided
prompt_until_input() {
    local prompt_message="$1"
    local return_var="$2"
    local user_input

    while true; do
        echo -n "$prompt_message"
        read user_input
        if [[ -n "$user_input" ]]; then
            break
        fi
    done
    eval "$return_var='$user_input'"
}

# Prompt the user for required variables
prompt_until_input "Enter desired PROJECT_ID (e.g. cfia-ai-lab): " PROJECT_ID
prompt_until_input "Enter your BILLING_ACCOUNT_ID (You can find this on the GCP Console under Billing): " BILLING_ACCOUNT_ID

# Create a new project
gcloud projects create $PROJECT_ID

# Set the project as the active project
gcloud config set project $PROJECT_ID

# Link the billing account to the project
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT_ID

# Retrieve and display a list of Google Cloud regions
echo "Available Google Cloud regions"
gcloud compute regions list --format=value(name)
echo

# Prompt user for necessary variables
prompt_until_input "Enter a Google Cloud region from the above list: " REGION
prompt_until_input "Enter a name for your Google Cloud project: " PROJECT_NAME
prompt_until_input "Enter the Docker repository name: " REPO_NAME
prompt_until_input "Enter a description for the Docker repository [Optional]: " DESCRIPTION
prompt_until_input "Enter a name for your service account: " SA_NAME
prompt_until_input "Enter a display name for the service account: " SA_DISPLAY_NAME
prompt_until_input "Choose a name for the JSON key file (without .json): " FILE_NAME

# Execute commands

# Create an artifact repository
gcloud artifacts repositories create $REPO_NAME \
   --repository-format=docker \
   --location=$REGION \
   --description="$DESCRIPTION"

# Create a service account (SA)
gcloud iam service-accounts create $SA_NAME --display-name "$SA_DISPLAY_NAME"

# Create the key for the service account (SA)
gcloud iam service-accounts keys create "$FILE_NAME.json" --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

# Automatically apply the roles to the service account
ROLES=(
    roles/artifactregistry.writer
    roles/iam.serviceAccountUser
    roles/run.admin
)

for ROLE in "${ROLES[@]}"; do
    gcloud projects add-iam-policy-binding $PROJECT_ID \
       --member=serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com \
       --role=$ROLE
done

echo "All commands executed successfully!"
