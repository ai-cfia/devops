# GitHub Repository Creation Guide

When creating a GitHub repository you need to follow a few organizational
standardization rules :

- When naming your repository use lowercase. This makes it easier for command
  line use.
- Use a dash ( - ) and not an underscore ( _ ) to separate words in the
  repository name.
- Make the repository public.
- Add a description.
- Create a LICENSE.md file.
- Protect your branches.
- Enable secret scanning and push protection.

## How to Create a LICENSE.md File

1. Create a new file and name it `LICENSE.md` :
    - ![Create
LICENSE.md](https://github.com/ai-cfia/devops/assets/9827730/540c2ee8-fc49-4c76-88c7-115ac8ffcae2)

2. Click on "Choose a license template."
3. Choose "MIT License," and all the needed information will be filled in for
   you.
    - ![Choose MIT
License](https://github.com/ai-cfia/devops/assets/9827730/f7d4576f-1a3e-4a95-98e8-7c67dbd32705)

4. Click on "Review and submit" to create your file.

## Why You Need to Protect Your Branches

Protecting branches in GitHub is essential for maintaining code integrity,
ensuring a consistent commit history, and safeguarding against disruptive
changes. By mandating code reviews, preventing force pushes, and requiring
scrutiny of contributions, branch protection provides a foundational layer of
security and quality control in collaborative projects.

## How to Protect Your Branch

1. Go to your repository's main page.
2. Click on the "Settings" option on the top right.
    - ![Settings](https://github.com/ai-cfia/devops/assets/9827730/5be87238-af3d-4c2c-b17b-8d765f5fbbee)

3. Click on the "Branches" tab on the right menu.
    - ![Branches
Tab](https://github.com/ai-cfia/devops/assets/9827730/5b5d85ef-5713-4c60-a519-6602f86e008a)

4. Make sure to check "Require a pull request before merging," and also ensure
   that "Require approvals" is checked. You can leave the default option for the
   number of required approvals.
    - ![Branch Protection
Settings](https://github.com/ai-cfia/devops/assets/9827730/fe2a4a22-19af-4f3b-96e1-03095c26ddeb)

## How to Enable Secret Scanning and Push Protection

Enabling secret scanning and push protection in GitHub repositories helps
prevent sensitive information, such as API keys, passwords, and tokens, from
being inadvertently exposed in your codebase. Secret scanning detects exposed
secrets, while push protection actively blocks commits containing known secrets.
If a secret is leaked, repository administrators receive an alert.

To enable these functionalities:

1. From the main page of your repository, click **Settings**. ![Repository
Settings](./images/{186D1DE0-B70F-4DAA-8267-D8029BB90F66}.png)

1. In the sidebar, scroll down to the **Security** section and click **Code security**.

1. Scroll down to the **Secret scanning** section and click **Enable**. ![Enable
Secret scanning](./images/{88B79545-E575-41D6-AAB5-EBD53195E25F}.png)

1. After enabling Secret scanning, the option to enable Push protection will
appear. Click **Enable**. ![Enable Push
protection](./images/{EE4585DB-1219-43A3-BDF0-B8E6F0ADCEDB}.png)
