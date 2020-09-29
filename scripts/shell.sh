#!/bin/bash

heroku config | grep -v "^===" | sed -e "s/^\([^:]*\): */\1=/g" > .env.production
docker-compose run edison_production /bin/bash
echo "" > .env.production
