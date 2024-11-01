from setuptools import setup, find_packages

setup(
    name='devsecops-scripts',
    version='1.0.0',
    packages=find_packages(),
    entry_points={
        'console_scripts': [
            'remove-previous-images=remove_previous_image.remove_previous_image:main',
            'webtop-template=webtop-template.main:main',
        ],
    },
    url='https://github.com/ai-cfia/devops.git',
    author='ai-cfia',
    author_email='devsecops@inspection.gc.ca',
    description='Every devops script used in dev, uat and production',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    install_requires=[
        'requests',
        'jinja2',
        'PyGithub',
        'python-dotenv'
    ],
)
