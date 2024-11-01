import sys
import os
from dotenv import load_dotenv

from jinja2 import Environment, FileSystemLoader
from github import Github

REPO_NAME = 'ai-cfia/howard'
FOLDER_PATH = 'templates'
HOWARD_DUMB_FILE_FOLDER = 'kubernetes/aks/apps/webtop'
TEMPLATES_NAMES = ['webtop-deployment.yaml.j2', 'webtop-ingress.yaml.j2', 'webtop-secrets.yaml.j2']

def render_template(username):
    file_loader = FileSystemLoader(FOLDER_PATH)
    env = Environment(loader=file_loader)

    os.makedirs(username, exist_ok=True)
    
    for i in TEMPLATES_NAMES:
        template_name = i
        template = env.get_template(template_name)
        rendered_content = template.render(
            username=username,
        )

        base_name = template_name.replace('.j2', '')
        output_filename = os.path.join(username, f"{username}-{base_name}")
        with open(output_filename, 'w') as f:
            f.write(rendered_content)

def create_github_pr(username, gh_access_token):
    g = Github(gh_access_token)
    repo = g.get_repo(REPO_NAME)
    
    branch_name = f"{username}-webtop-instance"
    
    source = repo.get_branch('main')
    repo.create_git_ref(ref=f'refs/heads/{branch_name}', sha=source.commit.sha)
    
    for root, _, files in os.walk(username):
        for file in files:
            file_path = os.path.join(root, file)
            with open(file_path, 'r') as file_content:
                content = file_content.read()
            repo_file_path = os.path.relpath(file_path, username)
            repo_file_path = os.path.join(HOWARD_DUMB_FILE_FOLDER, file)
            repo.create_file(
                path=repo_file_path,
                message=f'Adding {repo_file_path}',
                content=content,
                branch=branch_name
            )
    
    pr = repo.create_pull(
        title=f'Adding new webtop instance for {username}',
        body=f'Adding new webtop instance for {username}',
        head=branch_name,
        base='main'
    )
    
    print(f"Pull request created: {pr.html_url}")

if __name__ == '__main__':
    load_dotenv()

    gh_access_token = os.getenv("GITHUB_ACCESS_TOKEN")
    username = os.getenv("USERNAME")

    render_template(username)
    create_github_pr(username, gh_access_token)