# Creating a GitHub Token with Fine-Grained Permissions

Creating a fine-grained personal access token in GitHub allows you to perform specific actions within a repository, an organization, or other GitHub resources. This guide walks you through the steps to create such a token.

## Steps to Create the Token

1. **Access Developer Settings**:
   - Navigate to your GitHub profile.
   - Click on `Settings`.
   - Scroll down to the bottom and select `Developer settings`.

2. **Select Fine-Grained Token Option**:
   - Under the `Personal access tokens` section, choose the `Fine-grained token` option.

3. **Set Resource Owner**:
   - Change the `Resource owner` to the organization for which you want the token to have access.

4. **Define Permissions**:
   - Under the `Permissions` section, define the specific permissions your token requires.
   - Refer to the GitHub documentation on [permissions required for fine-grained personal access tokens](https://docs.github.com/en/rest/overview/permissions-required-for-fine-grained-personal-access-tokens?apiVersion=2022-11-28) to understand which permissions are necessary for the endpoints you wish to access.

## Important Notes

- Ensure that you only grant the minimum necessary permissions to perform your intended tasks.
- Keep your tokens secure and do not share them publicly.

You can find out the required permission of each script under the "Permission required" section of the each script's documentation.
