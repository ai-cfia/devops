#!/bin/bash
sudo service ssh start && \
sudo service ssh status && \
exec /usr/local/bin/start-notebook.py --IdentityProvider.token='' --ServerApp.base_url=/ipython/ --ServerApp.allow_origin='*' --ServerApp.allow_remote_access=True --ServerApp.port=8888 --ServerApp.open_browser=False
