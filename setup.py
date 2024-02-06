from setuptools import setup, find_packages

setup(
    name='devsecops-scripts',
    version='1.0.0',
    packages=find_packages(),
    url='https://github.com/ai-cfia/devops.git',
    author='ai-cfia',
    author_email='devsecops@inspection.gc.ca',
    description='Every devops script used in dev, uat and production',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    install_requires=[
        "requests"
    ],
)