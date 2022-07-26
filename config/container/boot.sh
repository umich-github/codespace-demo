#!/bin/bash

export RAILS_ENV=${RAILS_ENV:-production}
export FORMATION=${FORMATION:-web=1,work=0}

cd /app

bundle exec rails db:migrate

# run web app
exec foreman start -m $FORMATION
