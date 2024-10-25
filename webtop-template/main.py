import sys
import os
from jinja2 import Environment, FileSystemLoader

FOLDER_PATH = 'templates'
TEMPLATES_NAMES = ['webtop-deployment.yaml.j2', 'webtop-ingress.yaml.j2', 'webtop-secrets.yaml.j2', 'kustomization.yaml.j2']

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

if __name__ == '__main__':
    username = sys.argv[1]
    render_template(username)