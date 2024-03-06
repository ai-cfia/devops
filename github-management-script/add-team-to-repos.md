# GitHub Team Addition Script

This script is designed to automate the process of adding a specific team to all
repositories within a specified GitHub organization. It dynamically assigns
teams to repositories based on the repository naming conventions and ensures
that an administrative team is added to each repository.

## Functionality

- **Automated Team Assignment:** Automatically adds a specified team to all
  repositories within a given GitHub organization.
- **Dynamic Team Assignment:** The script assigns teams (`backend`, `frontend`,
  `db`) dynamically based on the naming convention of the repositories.
- **Admin Team Enforcement:** Ensures that an administrative team is added to
  every repository, regardless of its naming convention.

## Requirements

- **GitHub Personal Access Token (PAT):** You must have a GitHub Personal Access
  Token with appropriate permissions to add teams to repositories.

## Usage

1. **Prepare the Script:**
   - Ensure you have Node.js installed on your system.
   - Clone or download the script to your local machine.

2. **Configuration:**
   - Open the script in your text editor.
   - Fill in the `GITHUB_ORG`, `TEAM_PERMISSION` and
     `ADMIN_TEAM_SLUG` variables with the appropriate values for your GitHub
     organization and teams.

3. **Run the Script:**
   - Open your terminal and navigate to the directory containing the script.
   - Execute the script by running:

     ```sh
     ./add-team-to-repos.sh
     ```

   - When prompted, enter your GitHub Personal Access Token. This token is used
     to authenticate requests to the GitHub API.

4. **Operation:**
   - The script fetches all repositories from the specified organization.
   - It iterates over each repository, adding the specified team, and logs the
     progress in the console.
   - If the repository name includes specific keywords (e.g., 'backend',
     'frontend', 'db'), it assigns different teams based on these keywords.
   - The script also ensures that the administrative team is added to every
     repository, maintaining a consistent level of access control across all
     organizational repositories.
