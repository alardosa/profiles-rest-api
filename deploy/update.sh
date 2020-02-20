#!/usr/bin/env bash

set -e

PROJECT_BASE_PATH='/usr/local/apps/profiles-rest-api'

git pull
sudo $PROJECT_BASE_PATH/env/bin/python manage.py migrate
sudo $PROJECT_BASE_PATH/env/bin/python manage.py collectstatic --noinput
sudo supervisorctl reload profiles_api

echo "DONE! :)";
