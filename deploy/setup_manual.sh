#!/usr/bin/env bash

set -e

# TODO: Set to URL of git repo.
PROJECT_GIT_URL='https://github.com/alardosa/profiles-rest-api.git'

PROJECT_BASE_PATH='/usr/local/apps/profiles-rest-api'

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y python3-dev python3-venv sqlite python-pip supervisor nginx git

# Create project directory
sudo mkdir -p /usr/local/apps/profiles-rest-api
git clone https://github.com/alardosa/profiles-rest-api.git /usr/local/apps/profiles-rest-api

# Create virtual environment
sudo mkdir -p /usr/local/apps/profiles-rest-api/env
sudo python3 -m venv /usr/local/apps/profiles-rest-api/env

# Install python packages
sudo /usr/local/apps/profiles-rest-api/env/bin/pip install -r /usr/local/apps/profiles-rest-api/requirements.txt
sudo /usr/local/apps/profiles-rest-api/env/bin/pip install django
sudo /usr/local/apps/profiles-rest-api/env/bin/pip install djangorestframework
sudo /usr/local/apps/profiles-rest-api/env/bin/pip install uwsgi==2.0.18

# Run migrations and collectstatic
sudo /usr/local/apps/profiles-rest-api/env/bin/python -i /usr/local/apps/profiles-rest-api/manage.py migrate
sudo /usr/local/apps/profiles-rest-api/env/bin/python -i /usr/local/apps/profiles-rest-api/manage.py collectstatic --noinput

# Configure supervisor
sudo cp /usr/local/apps/profiles-rest-api/deploy/supervisor_profiles_api.conf /etc/supervisor/conf.d/profiles_api.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart profiles_api

# Configure nginx
sudo cp /usr/local/apps/profiles-rest-api/deploy/nginx_profiles_api.conf /etc/nginx/sites-available/profiles_api.conf
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/profiles_api.conf /etc/nginx/sites-enabled/profiles_api.conf
sudo systemctl restart nginx.service

echo "DONE! :)"
